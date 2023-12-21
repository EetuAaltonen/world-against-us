import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import AvailableInstance from "../instances/AvailableInstance.js";
import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";
import ContainerContentInfo from "../containers/ContainerContentInfo.js";
import NetworkInventoryStreamItems from "../network_inventory_stream/NetworkInventoryStreamItems.js";
import PlayerInfo from "../players/PlayerInfo.js";

import ParseJSONObjectToContainerAction from "../containers/ParseJSONObjectToContainerAction.js";
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
            const networkWorldStateSync = new NetworkWorldStateSync(
              this.networkHandler.worldStateHandler.dateTime.toJSONObject(),
              this.networkHandler.worldStateHandler.weather
            );
            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.SYNC_WORLD_STATE,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              worldStateSync.toJSONStruct(),
              PACKET_PRIORITY.HIGH
            );
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
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
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.SYNC_INSTANCE:
          {
            const formatInstance = instance.toJSONStruct();
            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.SYNC_INSTANCE,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              formatInstance,
              PACKET_PRIORITY.HIGH
            );
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
            );
            isPacketHandled = true;
          }
          break;
        case MESSAGE_TYPE.DATA_PLAYER_POSITION:
          {
            // TODO: Sync player position
            isPacketHandled = true;
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
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
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
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
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
                this.networkHandler.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkPacket,
                    [client],
                    networkPacket.priority
                  )
                );
                isPacketHandled = true;
              }
            }
          }
          break;
        case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
          {
            // TODO: Return a flag if container is already in-use by a player
            const containerId = networkPacket.payload;
            if (containerId !== undefined) {
              const contentCount =
                instance.containerHandler.getContainerContentCountById(
                  containerId
                );
              const containerContentInfo = new ContainerContentInfo(
                containerId,
                contentCount
              );
              if (containerContentInfo.contentCount === -1) {
                instance.containerHandler.initContainer(containerId);
              }

              const networkPacketHeader = new NetworkPacketHeader(
                MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT,
                client.uuid
              );
              const networkPacket = new NetworkPacket(
                networkPacketHeader,
                containerContentInfo,
                PACKET_PRIORITY.DEFAULT
              );
              this.networkHandler.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkPacket,
                  [client],
                  networkPacket.priority
                )
              );
              isPacketHandled = true;
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
                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkPacket,
                      [client],
                      networkPacket.priority
                    )
                  );
                  isPacketHandled = true;
                }
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
        case MESSAGE_TYPE.CONTAINER_INVENTORY_ADD_ITEM:
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
        case MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM:
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
        case MESSAGE_TYPE.PATROL_STATE:
          {
            const patrolState = networkPacket.payload;
            if (patrolState !== undefined) {
              if (patrolState.instanceId === instance.instanceId) {
                if (instance.handlePatrolState(patrolState)) {
                  this.networkHandler.queueAcknowledgmentResponse(client);
                }
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
            this.networkHandler.packetQueue.enqueue(
              new NetworkQueueEntry(
                networkPacket,
                [client],
                networkPacket.priority
              )
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
                if (
                  this.instanceHandler.activeOperationsScoutStream === undefined
                ) {
                  this.instanceHandler.activeOperationsScoutStream =
                    scoutInstanceId;

                  // TODO: Initialize scouting drone
                  // Broad cast scouting drone sync withing scouted instance

                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM,
                    client.uuid
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    undefined,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkPacket,
                      [client],
                      networkPacket.priority
                    )
                  );
                  isPacketHandled = true;
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
          {
            const scoutInstanceId = networkPacket.payload;
            if (scoutInstanceId !== undefined) {
              if (
                this.instanceHandler.activeOperationsScoutStream ===
                scoutInstanceId
              ) {
                const scoutInstance =
                  this.instanceHandler.getInstance(scoutInstanceId);
                if (scoutInstance !== undefined) {
                  const formatScoutInstance = scoutInstance.toJSONStruct();

                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM,
                    client.uuid
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    formatScoutInstance,
                    PACKET_PRIORITY.DEFAULT
                  );
                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkPacket,
                      [client],
                      networkPacket.priority
                    )
                  );
                  isPacketHandled = true;
                }
              }
            }
          }
          break;
        case MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM:
          {
            const scoutInstanceId = networkPacket.payload;
            if (scoutInstanceId !== undefined) {
              if (
                this.instanceHandler.activeOperationsScoutStream ===
                scoutInstanceId
              ) {
                this.instanceHandler.activeOperationsScoutStream = undefined;
                const networkPacketHeader = new NetworkPacketHeader(
                  MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM,
                  client.uuid
                );
                const networkPacket = new NetworkPacket(
                  networkPacketHeader,
                  undefined,
                  PACKET_PRIORITY.DEFAULT
                );
                this.networkHandler.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkPacket,
                    [client],
                    networkPacket.priority
                  )
                );
                isPacketHandled = true;
              }
            }
          }
          break;
      }
    }
    return isPacketHandled;
  }
}
