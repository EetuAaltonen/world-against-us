import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import PlayerListInfo from "../players/PlayerListInfo.js";
import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";
import ContainerContentInfo from "../containers/ContainerContentInfo.js";
import NetworkInventoryStreamItems from "../network_inventory_stream/NetworkInventoryStreamItems.js";

import ParseJSONObjectToContainerAction from "../containers/ParseJSONObjectToContainerAction.js";
import NetworkWorldStateSync from "../world_state/NetworkWorldStateSync.js";

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
              networkWorldStateSync,
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
            const formatInstance = instance.toJSONObject();
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
            const playerListInfoArray = clients.map((client) => {
              let playerName = "Player X";
              let instanceId = client.instanceId;
              let roomIndex = "";
              let instance = this.instanceHandler.getInstance(instanceId);
              console.log;
              if (instance !== undefined) {
                roomIndex = instance.roomIndex;
              }
              return new PlayerListInfo(
                playerName,
                instanceId ?? -1,
                roomIndex
              );
            });

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REQUEST_PLAYER_LIST,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              { player_list: playerListInfoArray },
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
            const instanceIds = this.instanceHandler
              .getInstanceIds()
              .filter((instanceId) => {
                return parseInt(instanceId) !== 0;
              });
            const instances = instanceIds
              .filter((instanceId) => {
                let instance = this.instanceHandler.getInstance(instanceId);
                if (instance !== undefined) {
                  return instance.parentInstanceId === undefined;
                }
                return false;
              })
              .map((instanceId) => {
                let instance = this.instanceHandler.getInstance(instanceId);
                // TODO: Create object class for this
                return {
                  instance_id: instanceId,
                  room_index: instance.roomIndex,
                  player_count: instance.getPlayerCount(),
                };
              });

            const networkPacketHeader = new NetworkPacketHeader(
              MESSAGE_TYPE.REQUEST_INSTANCE_LIST,
              client.uuid
            );
            const networkPacket = new NetworkPacket(
              networkPacketHeader,
              { available_instances: instances },
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
            const containerInventoryStream = networkPacket.payload;
            if (containerInventoryStream !== undefined) {
              const container = instance.containerHandler.getContainerById(
                containerInventoryStream.targetContainerId
              );
              if (container !== undefined) {
                containerInventoryStream.targetInventory = container.inventory;
                // TODO: Support multiple concurrent inventory streams
                instance.containerHandler.activeInventoryStream =
                  containerInventoryStream;

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
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
          {
            const activeInventoryStream =
              instance.containerHandler.activeInventoryStream;
            if (activeInventoryStream !== undefined) {
              if (activeInventoryStream.isStreamSending) {
                const containerInventoryStreamItems = networkPacket.payload;
                if (containerInventoryStreamItems !== undefined) {
                  if (activeInventoryStream.targetInventory !== undefined) {
                    if (
                      activeInventoryStream.targetInventory.addItems(
                        containerInventoryStreamItems.items
                      )
                    ) {
                      const networkPacketHeader = new NetworkPacketHeader(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
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
              } else {
                const activeInventoryStream =
                  instance.containerHandler.activeInventoryStream;
                if (activeInventoryStream !== undefined) {
                  const items = activeInventoryStream.FetchNextItems();
                  if (items.length > 0) {
                    const inventoryStreamItems =
                      new NetworkInventoryStreamItems(items);

                    const networkPacketHeader = new NetworkPacketHeader(
                      MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
                      client.uuid
                    );
                    const networkPacket = new NetworkPacket(
                      networkPacketHeader,
                      inventoryStreamItems,
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
                  } else {
                    // TODO: Duplicate code with all MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM responses
                    const networkPacketHeader = new NetworkPacketHeader(
                      MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
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
          }
          break;
        case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
          {
            const activeInventoryStream =
              instance.containerHandler.activeInventoryStream;
            if (activeInventoryStream.isStreamSending) {
              instance.containerHandler.activeInventoryStream = undefined;

              const networkPacketHeader = new NetworkPacketHeader(
                MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
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
            } else {
              this.networkHandler.onInvalidRequest(
                "Invalid 'end inventory stream' request",
                rinfo
              );
              isPacketHandled = true;
            }
          }
          break;
        case MESSAGE_TYPE.CONTAINER_INVENTORY_ADD_ITEM:
          {
            // TODO: Move all parse functions under the packet parser
            const containerInventoryActionInfo =
              ParseJSONObjectToContainerAction(networkPacket.payload);
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
      }
    }
    return isPacketHandled;
  }
}
