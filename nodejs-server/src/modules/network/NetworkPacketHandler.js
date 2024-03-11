import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";
import INVALID_REQUEST_ACTION from "../invalid_request/InvalidRequestAction.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";

import WorldStateSync from "../world_state/WorldStateSync.js";
import PlayerInfo from "../players/PlayerInfo.js";
import RemotePlayerInfo from "../players/RemotePlayerInfo.js";
import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";
import ContainerContentInfo from "../containers/ContainerContentInfo.js";
import OperationsScoutStream from "../operations_center/OperationsScoutStream.js";
import ScoutingDrone from "../operations_center/ScoutingDrone.js";

import ParseJSONStructToContainerAction from "../containers/ParseJSONStructToContainerAction.js";
import FormatArrayToJSONStructArray from "../formatting/FormatArrayToJSONStructArray.js";

export default class NetworkPacketHandler {
  constructor(
    networkHandler,
    networkPacketBuilder,
    clientHandler,
    instanceHandler
  ) {
    this.networkHandler = networkHandler;
    this.networkPacketBuilder = networkPacketBuilder;
    this.clientHandler = clientHandler;
    this.instanceHandler = instanceHandler;
  }

  handlePacket(client, rinfo, networkPacket) {
    let isPacketHandled = false;
    const instance = this.instanceHandler.getInstance(client.instanceId);
    if (instance !== undefined) {
      switch (networkPacket.header.messageType) {
        case MESSAGE_TYPE.SYNC_WORLD_STATE:
          {
            const worldStateSync = new WorldStateSync(
              this.networkHandler.worldStateHandler.dateTime,
              this.networkHandler.worldStateHandler.weather
            );
            const formatWorldStateSync = worldStateSync.toJSONStruct();

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.SYNC_WORLD_STATE,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              formatWorldStateSync,
              PACKET_PRIORITY.HIGH
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.DATA_PLAYER_SYNC:
          {
            // TODO: Sync player data within the instance
            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.DATA_PLAYER_SYNC,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              undefined,
              PACKET_PRIORITY.HIGH
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.SYNC_INSTANCE:
          {
            // Broadcast about entered client within the instance
            const remotePlayerInfo = new RemotePlayerInfo(
              client.uuid,
              client.playerTag
            );
            const clientsToBroadcast =
              this.clientHandler.getClientsToBroadcastInstance(
                instance.instanceId,
                client.uuid
              );
            const broadcastNetworkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REMOTE_ENTERED_THE_INSTANCE,
              client.uuid
            );
            const broadcastNetworkPacket = new NetworkPacket(
              broadcastNetworkPacketHeader,
              remotePlayerInfo,
              PACKET_PRIORITY.DEFAULT
            );
            this.networkHandler.broadcast(
              broadcastNetworkPacket,
              clientsToBroadcast
            );

            // Response with instance data
            const formatInstance = instance.toJSONStruct();
            let formatScoutingDrone = undefined;
            const activeOperationsScoutStream =
              this.instanceHandler.activeOperationsScoutStream;
            if (activeOperationsScoutStream !== undefined) {
              if (
                activeOperationsScoutStream.instanceId === instance.instanceId
              ) {
                formatScoutingDrone =
                  activeOperationsScoutStream.scoutingDrone.toJSONStruct();
              }
            }

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.SYNC_INSTANCE,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              {
                region: formatInstance,
                scouting_drone: formatScoutingDrone,
              },
              PACKET_PRIORITY.HIGH
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.PLAYER_DATA_POSITION:
          {
            const newPosition = networkPacket.payload;
            if (newPosition !== undefined) {
              const player = instance.getPlayer(client.uuid);
              if (player !== undefined) {
                player.position = newPosition;

                // Broadcast about updated player position data
                const clientsToBroadcast =
                  this.clientHandler.getClientsToBroadcastInstance(
                    instance.instanceId,
                    client.uuid
                  );
                const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                  MESSAGE_TYPE.REMOTE_DATA_POSITION,
                  client.uuid
                );
                const broadcastNetworkPacket = new NetworkPacket(
                  broadcastNetworkPacketHeader,
                  player.toJSONStruct(),
                  PACKET_PRIORITY.DEFAULT
                );
                this.networkHandler.broadcast(
                  broadcastNetworkPacket,
                  clientsToBroadcast
                );

                // Acknowledgment is sent with new snapshot
                isPacketHandled = true;
              }
            }
          }
          break;
        case MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT:
          {
            const deviceInputMovement = networkPacket.payload;
            if (deviceInputMovement !== undefined) {
              const player = instance.getPlayer(client.uuid);
              if (player !== undefined) {
                player.inputMovement = deviceInputMovement;

                // Broadcast about device input change within the instance
                const clientsToBroadcast =
                  this.clientHandler.getClientsToBroadcastInstance(
                    instance.instanceId,
                    client.uuid
                  );
                const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                  MESSAGE_TYPE.REMOTE_DATA_MOVEMENT_INPUT,
                  client.uuid
                );
                const broadcastNetworkPacket = new NetworkPacket(
                  broadcastNetworkPacketHeader,
                  {
                    network_id: client.uuid,
                    device_input_movement: player.inputMovement.toJSONStruct(),
                  },
                  PACKET_PRIORITY.DEFAULT
                );
                this.networkHandler.broadcast(
                  broadcastNetworkPacket,
                  clientsToBroadcast
                );
                isPacketHandled = true;
              }
            }
          }
          break;
        case MESSAGE_TYPE.REQUEST_PLAYER_LIST:
          {
            const clients = this.clientHandler.getAllClients();
            const playerInfoArray = clients.map((client) => {
              let playerName = "Player X";
              let instanceId = client.instanceId;
              let roomIndex = "";
              let instance = this.instanceHandler.getInstance(instanceId);
              if (instance !== undefined) {
                roomIndex = instance.roomIndex;
              }
              return new PlayerInfo(playerName, instanceId ?? -1, roomIndex);
            });
            const formatPlayerInfoArray =
              FormatArrayToJSONStructArray(playerInfoArray);

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REQUEST_PLAYER_LIST,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              { player_list: formatPlayerInfoArray },
              PACKET_PRIORITY.DEFAULT
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
          {
            const availableInstances =
              this.instanceHandler.getAvailableInstances(true, true);
            const formatAvailableInstanceArray =
              FormatArrayToJSONStructArray(availableInstances);

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REQUEST_INSTANCE_LIST,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              { available_instances: formatAvailableInstanceArray },
              PACKET_PRIORITY.DEFAULT
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
          {
            const fastTravelInfo = networkPacket.payload;
            if (fastTravelInfo !== undefined) {
              const destinationInstanceId =
                this.instanceHandler.fastTravelPlayer(
                  client.uuid,
                  fastTravelInfo.sourceInstanceId,
                  fastTravelInfo.destinationRoomIndex,
                  fastTravelInfo.destinationInstanceId
                );
              const destinationInstance = this.instanceHandler.getInstance(
                destinationInstanceId
              );
              if (destinationInstance !== undefined) {
                // Set new instance
                client.setInstanceId(destinationInstanceId);

                // Broadcast if player returns to camp
                const remotePlayerInfo = new RemotePlayerInfo(
                  client.uuid,
                  client.playerTag
                );
                if (
                  destinationInstance.instanceId === this.instanceHandler.campId
                ) {
                  const clientsToBroadcast =
                    this.clientHandler.getClientsToBroadcastInGame(client.uuid);
                  const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.REMOTE_RETURNED_TO_CAMP,
                    client.uuid
                  );
                  const broadcastNetworkPacket = new NetworkPacket(
                    broadcastNetworkPacketHeader,
                    remotePlayerInfo,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.broadcast(
                    broadcastNetworkPacket,
                    clientsToBroadcast
                  );
                } else {
                  // Broadcast about left client within the instance
                  const clientsToBroadcast =
                    this.clientHandler.getClientsToBroadcastInstance(
                      fastTravelInfo.sourceInstanceId
                    );
                  const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.REMOTE_LEFT_THE_INSTANCE,
                    client.uuid
                  );
                  const broadcastNetworkPacket = new NetworkPacket(
                    broadcastNetworkPacketHeader,
                    remotePlayerInfo,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.broadcast(
                    broadcastNetworkPacket,
                    clientsToBroadcast
                  );
                }

                // Response with fast travel info
                const payloadFastTravelInfo = new WorldMapFastTravelInfo(
                  fastTravelInfo.sourceInstanceId,
                  destinationInstanceId,
                  destinationInstance.roomIndex
                );
                const networkPacketHeader = new NetworkPacketHeader(
                  MESSAGE_TYPE.REQUEST_FAST_TRAVEL,
                  client.uuid
                );
                const networkPacket = new NetworkPacket(
                  networkPacketHeader,
                  payloadFastTravelInfo,
                  PACKET_PRIORITY.DEFAULT
                );
                this.networkHandler.queueNetworkPacket(
                  new NetworkQueueEntry(networkPacket, [client])
                );
                isPacketHandled = true;
              }
            }
          }
          break;
        case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
          {
            const containerRequestInfo = networkPacket.payload;
            if (containerRequestInfo !== undefined) {
              if (containerRequestInfo.instanceId === instance.instanceId) {
                const containerId = containerRequestInfo.containerId;
                let container =
                  instance.containerHandler.getContainerById(containerId);

                let contentCount = -1; // Default content count
                if (container === undefined) {
                  // Add new container
                  instance.containerHandler.addContainer(containerId);
                  // Fetch added container
                  container =
                    instance.containerHandler.getContainerById(containerId);
                } else {
                  // Fetch content count
                  contentCount = container.inventory.getItemCount();
                }

                if (container.requestingClient === undefined) {
                  // Set client access
                  container.requestingClient = client.uuid;
                  const containerContentInfo = new ContainerContentInfo(
                    containerId,
                    contentCount
                  );

                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT,
                    client.uuid
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    containerContentInfo,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.queueNetworkPacket(
                    new NetworkQueueEntry(networkPacket, [client])
                  );
                  isPacketHandled = true;
                } else {
                  isPacketHandled = this.networkHandler.onInvalidRequest(
                    new InvalidRequestInfo(
                      INVALID_REQUEST_ACTION.CANCEL_ACTION,
                      networkPacket.header.messageType,
                      "Another player already looting the container"
                    ),
                    rinfo
                  );
                }
              } else {
                isPacketHandled = this.networkHandler.onInvalidRequest(
                  new InvalidRequestInfo(
                    INVALID_REQUEST_ACTION.CANCEL_ACTION,
                    networkPacket.header.messageType,
                    "Invalid region ID on request container content"
                  ),
                  rinfo
                );
              }
            }
          }
          break;
        case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
          {
            const inventoryStream = networkPacket.payload;
            if (inventoryStream !== undefined) {
              const container = instance.containerHandler.getContainerById(
                inventoryStream.inventoryId
              );
              if (container !== undefined) {
                const activeInventoryStream =
                  instance.containerHandler.getActiveInventoryStream(
                    inventoryStream.inventoryId
                  );
                if (activeInventoryStream === undefined) {
                  inventoryStream.requestingClient = client.uuid;
                  inventoryStream.targetInventory = container.inventory;

                  if (
                    instance.containerHandler.addActiveInventoryStream(
                      inventoryStream
                    )
                  ) {
                    const networkPacketHeader = new NetworkPacketHeader(
                      MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM,
                      client.uuid
                    );
                    const networkPacket = new NetworkPacket(
                      networkPacketHeader,
                      undefined,
                      PACKET_PRIORITY.DEFAULT
                    );
                    this.networkHandler.queueNetworkPacket(
                      new NetworkQueueEntry(networkPacket, [client])
                    );
                    isPacketHandled = true;
                  }
                } else {
                  isPacketHandled = this.networkHandler.onInvalidRequest(
                    new InvalidRequestInfo(
                      INVALID_REQUEST_ACTION.CANCEL_ACTION,
                      networkPacket.header.messageType,
                      "Another player already looting the container"
                    ),
                    rinfo
                  );
                }
              } else {
                isPacketHandled = this.networkHandler.onInvalidRequest(
                  new InvalidRequestInfo(
                    INVALID_REQUEST_ACTION.CANCEL_ACTION,
                    networkPacket.header.messageType,
                    "Unknown container"
                  ),
                  rinfo
                );
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
          {
            const inventoryStreamItems = networkPacket.payload;
            if (inventoryStreamItems !== undefined) {
              const activeInventoryStream =
                instance.containerHandler.getActiveInventoryStream(
                  inventoryStreamItems.inventoryId
                );
              if (activeInventoryStream !== undefined) {
                if (activeInventoryStream.requestingClient === client.uuid) {
                  if (inventoryStreamItems.instanceId === instance.instanceId) {
                    if (
                      activeInventoryStream.inventoryId ==
                      inventoryStreamItems.inventoryId
                    ) {
                      if (activeInventoryStream.isStreamSending) {
                        if (
                          activeInventoryStream.targetInventory !== undefined
                        ) {
                          if (
                            activeInventoryStream.targetInventory.addItems(
                              inventoryStreamItems.items
                            )
                          ) {
                            isPacketHandled =
                              instance.containerHandler.requestNextInventoryStreamItems(
                                activeInventoryStream.inventoryId,
                                instance.instanceId,
                                client
                              );
                          }
                        }
                      } else {
                        isPacketHandled =
                          instance.containerHandler.sendNextInventoryStreamItems(
                            activeInventoryStream,
                            instance.instanceId,
                            client
                          );
                      }
                    }
                  }
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
          {
            const inventoryStreamItems = networkPacket.payload;
            if (inventoryStreamItems !== undefined) {
              const activeInventoryStream =
                instance.containerHandler.getActiveInventoryStream(
                  inventoryStreamItems.inventoryId
                );
              if (activeInventoryStream !== undefined) {
                if (activeInventoryStream.requestingClient === client.uuid) {
                  if (inventoryStreamItems.instanceId === instance.instanceId) {
                    if (
                      activeInventoryStream.inventoryId ==
                      inventoryStreamItems.inventoryId
                    ) {
                      instance.containerHandler.removeActiveInventoryStream(
                        activeInventoryStream.inventoryId
                      );
                      isPacketHandled =
                        this.networkHandler.queueAcknowledgmentResponse(client);
                    }
                  }
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_DEPOSIT_ITEM:
          {
            // TODO: Check that inventory is not streaming actively
            // TODO: Move all parse functions under the packet parser
            // And rename to InventoryActionInfo
            const containerInventoryActionInfo =
              ParseJSONStructToContainerAction(networkPacket.payload);
            if (containerInventoryActionInfo !== undefined) {
              const item = containerInventoryActionInfo.item;
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (container.inventory.addItem(item)) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_STACK_ITEM:
          {
            // TODO: Check that inventory is not streaming actively
            // TODO: Move all parse functions under the packet parser
            // And rename to InventoryActionInfo
            const containerInventoryActionInfo =
              ParseJSONStructToContainerAction(networkPacket.payload);
            if (containerInventoryActionInfo !== undefined) {
              const item = containerInventoryActionInfo.item;
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (container.inventory.stackItem(item)) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM:
          {
            const containerInventoryActionInfo = networkPacket.payload;
            if (containerInventoryActionInfo !== undefined) {
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (
                  container.inventory.identifyItemByGridIndex(
                    containerInventoryActionInfo.sourceGridIndex
                  )
                ) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM:
          {
            const containerInventoryActionInfo = networkPacket.payload;
            if (containerInventoryActionInfo !== undefined) {
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (
                  container.inventory.rotateItemByGridIndex(
                    containerInventoryActionInfo.sourceGridIndex,
                    containerInventoryActionInfo.isRotated
                  )
                ) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_WITHDRAW_ITEM:
          {
            const containerInventoryActionInfo = networkPacket.payload;
            if (containerInventoryActionInfo !== undefined) {
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (
                  container.inventory.removeItemByGridIndex(
                    containerInventoryActionInfo.sourceGridIndex
                  )
                ) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_DELETE_ITEM:
          {
            const containerInventoryActionInfo = networkPacket.payload;
            if (containerInventoryActionInfo !== undefined) {
              const container = instance.containerHandler.getContainerById(
                containerInventoryActionInfo.containerId
              );
              if (container !== undefined) {
                if (
                  container.inventory.removeItemByGridIndex(
                    containerInventoryActionInfo.sourceGridIndex
                  )
                ) {
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.RELEASE_CONTAINER_CONTENT:
          {
            const containerRequestInfo = networkPacket.payload;
            if (containerRequestInfo !== undefined) {
              if (containerRequestInfo.instanceId === instance.instanceId) {
                const containerId = containerRequestInfo.containerId;
                const container =
                  instance.containerHandler.getContainerById(containerId);
                if (container !== undefined) {
                  if (container.requestingClient === client.uuid) {
                    // Reset client access
                    container.requestingClient = undefined;

                    // Reset active inventory stream if release container content
                    // arrives before inventory stream end request
                    if (
                      instance.containerHandler.getActiveInventoryStream(
                        containerId
                      ) !== undefined
                    ) {
                      instance.containerHandler.removeActiveInventoryStream(
                        containerId
                      );

                      const defaultCampStorageContainer =
                        this.instanceHandler.getDefaultCampStorageContainer();
                      const campStorageContainerId =
                        defaultCampStorageContainer !== undefined
                          ? defaultCampStorageContainer.containerId
                          : undefined;
                      // Check that container is not a default camp storage
                      if (containerId !== campStorageContainerId) {
                        // Rollback interrupted inventory stream by deleting the container
                        instance.containerHandler.removeContainer(containerId);
                      }
                    }

                    isPacketHandled =
                      this.networkHandler.queueAcknowledgmentResponse(client);
                  }
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.SYNC_PATROL_STATE:
          {
            const patrolState = networkPacket.payload;
            if (patrolState !== undefined) {
              if (patrolState.instanceId === instance.instanceId) {
                if (instance.syncPatrolState(patrolState)) {
                  // Broadcast about new patrol state within the instance
                  this.networkHandler.broadcastPatrolState(
                    instance.instanceId,
                    patrolState,
                    client.uuid
                  );

                  // Respond with acknowledgment
                  isPacketHandled =
                    this.networkHandler.queueAcknowledgmentResponse(client);
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA:
          {
            const patrolsSnapshotData = networkPacket.payload;
            if (patrolsSnapshotData !== undefined) {
              if (patrolsSnapshotData.instanceId == instance.instanceId) {
                if (patrolsSnapshotData.localPatrols.length > 0) {
                  patrolsSnapshotData.localPatrols.forEach(
                    (patrolSnapshotData) => {
                      const patrol = instance.getPatrol(
                        patrolSnapshotData.patrol_id
                      );
                      if (patrol !== undefined) {
                        patrol.position.x = patrolSnapshotData.position.X;
                        patrol.position.y = patrolSnapshotData.position.X;
                        patrol.routeProgress = patrolSnapshotData.routeProgress;
                      }
                    }
                  );
                }

                // Broadcast patrols snapshot data withing instance
                const clientsToBroadcast =
                  this.clientHandler.getClientsToBroadcastInstance(
                    instance.instanceId,
                    client.uuid
                  );
                const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                  MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA,
                  client.uuid
                );
                const broadcastNetworkPacket = new NetworkPacket(
                  broadcastNetworkPacketHeader,
                  patrolsSnapshotData,
                  PACKET_PRIORITY.DEFAULT
                );
                this.networkHandler.broadcast(
                  broadcastNetworkPacket,
                  clientsToBroadcast
                );

                // Patrol snapshot data is routine and only the latest message takes effect
                // No guarantee for delivery required
                isPacketHandled = true;
              }
            }
          }
          break;
        case MESSAGE_TYPE.REQUEST_SCOUT_LIST:
          {
            const availableInstances =
              this.instanceHandler.getAvailableInstances(true, false);
            const formatAvailableInstanceArray =
              FormatArrayToJSONStructArray(availableInstances);

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REQUEST_SCOUT_LIST,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              { available_instances: formatAvailableInstanceArray },
              PACKET_PRIORITY.DEFAULT
            );
            this.networkHandler.queueNetworkPacket(
              new NetworkQueueEntry(networkPacket, [client])
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM:
          {
            const scoutInstanceId = networkPacket.payload;
            if (scoutInstanceId !== undefined) {
              const scoutInstance =
                this.instanceHandler.getInstance(scoutInstanceId);
              if (scoutInstance !== undefined) {
                let isStreamInterruptible = true;
                const activeOperationsScoutStream =
                  this.instanceHandler.activeOperationsScoutStream;
                if (activeOperationsScoutStream !== undefined) {
                  isStreamInterruptible =
                    activeOperationsScoutStream.operatingClient === client.uuid;

                  // Broadcast scouting drone leave withing prior scouted instance
                  if (
                    scoutInstance.instanceId !=
                    activeOperationsScoutStream.instanceId
                  ) {
                    // Broadcast destroy scouting drone withing scouted instance
                    this.broadcastScoutingDroneDestroy(scoutInstanceId, client);
                  }
                }

                if (isStreamInterruptible) {
                  const scoutingDrone = new ScoutingDrone(scoutInstanceId);
                  this.instanceHandler.activeOperationsScoutStream =
                    new OperationsScoutStream(
                      scoutInstanceId,
                      scoutingDrone,
                      client.uuid
                    );

                  // Broadcast scouting drone sync withing scouted instance
                  const formatScoutingDrone = scoutingDrone.toJSONStruct();
                  const clientsToBroadcast =
                    this.clientHandler.getClientsToBroadcastInstance(
                      scoutInstanceId
                    );
                  const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.SYNC_SCOUTING_DRONE_DATA,
                    client.uuid
                  );
                  const broadcastNetworkPacket = new NetworkPacket(
                    broadcastNetworkPacketHeader,
                    formatScoutingDrone,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.broadcast(
                    broadcastNetworkPacket,
                    clientsToBroadcast
                  );

                  // Response with start operations scout stream
                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM,
                    client.uuid
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    undefined,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.queueNetworkPacket(
                    new NetworkQueueEntry(networkPacket, [client])
                  );
                  isPacketHandled = true;
                } else {
                  isPacketHandled = this.networkHandler.onInvalidRequest(
                    new InvalidRequestInfo(
                      INVALID_REQUEST_ACTION.CANCEL_ACTION,
                      networkPacket.header.messageType,
                      "Another player already operating the scout"
                    ),
                    rinfo
                  );
                }
              } else {
                isPacketHandled = this.networkHandler.onInvalidRequest(
                  new InvalidRequestInfo(
                    INVALID_REQUEST_ACTION.CANCEL_ACTION,
                    networkPacket.header.messageType,
                    "Instance to scout is currently unavailable"
                  ),
                  rinfo
                );
              }
            }
          }
          break;
        case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
          {
            const scoutingDrone = networkPacket.payload;
            if (scoutingDrone !== undefined) {
              const activeOperationsScoutStream =
                this.instanceHandler.activeOperationsScoutStream;
              if (
                activeOperationsScoutStream.instanceId ===
                scoutingDrone.instanceId
              ) {
                const scoutInstance = this.instanceHandler.getInstance(
                  scoutingDrone.instanceId
                );
                if (scoutInstance !== undefined) {
                  activeOperationsScoutStream.scoutingDrone.position.x =
                    scoutingDrone.position.x;
                  activeOperationsScoutStream.scoutingDrone.position.y =
                    scoutingDrone.position.y;

                  // Broadcast scouting drone position withing scouted instance
                  const formatScoutingDrone =
                    activeOperationsScoutStream.scoutingDrone.toJSONStruct();
                  const clientsToBroadcast =
                    this.clientHandler.getClientsToBroadcastInstance(
                      scoutingDrone.instanceId
                    );
                  const broadcastNetworkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.SCOUTING_DRONE_DATA_POSITION,
                    client.uuid
                  );
                  const broadcastNetworkPacket = new NetworkPacket(
                    broadcastNetworkPacketHeader,
                    formatScoutingDrone,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.broadcast(
                    broadcastNetworkPacket,
                    clientsToBroadcast
                  );

                  // Response with scouted instance data
                  const scoutInstanceSnapshot =
                    scoutInstance.fetchInstanceSnapshot();
                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM,
                    client.uuid
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    scoutInstanceSnapshot,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.queueNetworkPacket(
                    new NetworkQueueEntry(networkPacket, [client])
                  );
                  isPacketHandled = true;
                } else {
                  // End operations scout stream if instance has deleted
                  isPacketHandled = this.endOperationsScoutStream(
                    scoutingDrone.instanceId,
                    client
                  );
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM:
          {
            const scoutInstanceId = networkPacket.payload;
            if (scoutInstanceId !== undefined) {
              isPacketHandled = this.endOperationsScoutStream(
                scoutInstanceId,
                client
              );
            }
          }
          break;
      }
    }
    return isPacketHandled;
  }

  broadcastScoutingDroneDestroy(scoutInstanceId, client) {
    // Broadcast scouting drone destroy withing scouted instance
    const activeOperationsScoutStream =
      this.instanceHandler.activeOperationsScoutStream;
    if (activeOperationsScoutStream !== undefined) {
      if (activeOperationsScoutStream.instanceId === scoutInstanceId) {
        const formatScoutingDrone =
          activeOperationsScoutStream.scoutingDrone.toJSONStruct();
        const clientsToBroadcast =
          this.clientHandler.getClientsToBroadcastInstance(scoutInstanceId);
        const broadcastNetworkPacketHeader = new NetworkPacketHeader(
          MESSAGE_TYPE.DESTROY_SCOUTING_DRONE_DATA,
          client.uuid
        );
        const broadcastNetworkPacket = new NetworkPacket(
          broadcastNetworkPacketHeader,
          formatScoutingDrone,
          PACKET_PRIORITY.DEFAULT
        );
        this.networkHandler.broadcast(
          broadcastNetworkPacket,
          clientsToBroadcast
        );
      }
    }
  }

  endOperationsScoutStream(scoutInstanceId, client) {
    let isScoutStreamEnded = false;
    const activeOperationsScoutStream =
      this.instanceHandler.activeOperationsScoutStream;
    if (activeOperationsScoutStream !== undefined) {
      if (activeOperationsScoutStream.instanceId === scoutInstanceId) {
        this.instanceHandler.activeOperationsScoutStream = undefined;

        // Broadcast destroy scouting drone withing scouted instance
        this.broadcastScoutingDroneDestroy(scoutInstanceId, client);

        // Response with end operations scout stream
        const networkPacketHeader = new NetworkPacketHeader(
          MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM,
          client.uuid
        );
        const networkPacket = new NetworkPacket(
          networkPacketHeader,
          undefined,
          PACKET_PRIORITY.DEFAULT
        );
        this.networkHandler.queueNetworkPacket(
          new NetworkQueueEntry(networkPacket, [client])
        );
        isScoutStreamEnded = true;
      }
    }
    return isScoutStreamEnded;
  }
}
