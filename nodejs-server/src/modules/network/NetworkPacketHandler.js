import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";
import INVENTORY_TYPE from "../inventory/InventoryType.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";
import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";
import ContainerContentInfo from "../containers/ContainerContentInfo.js";
import NetworkInventoryStreamItems from "../network_inventory_stream/NetworkInventoryStreamItems.js";

import ParseJSONObjectToContainerAction from "../containers/ParseJSONObjectToContainerAction.js";
import NetworkWorldStateSync from "../world_state/NetworkWorldStateSync.js";

export default class NetworkPacketHandler {
  constructor(networkHandler, networkPacketBuilder, instanceHandler) {
    this.networkHandler = networkHandler;
    this.networkPacketBuilder = networkPacketBuilder;
    this.instanceHandler = instanceHandler;
  }

  handlePacket(client, networkPacket) {
    let isPacketHandled = false;
    if (networkPacket !== undefined) {
      const acknowledgmentId = networkPacket.header.acknowledgmentId;
      const instance = this.instanceHandler.getInstance(client.instanceId);
      if (instance !== undefined) {
        switch (networkPacket.header.messageType) {
          case MESSAGE_TYPE.SYNC_WORLD_STATE:
            {
              const networkWorldStateSync = new NetworkWorldStateSync(
                this.networkHandler.worldStateHandler.dateTime.toJSONObject(),
                this.networkHandler.worldStateHandler.weather
              );
              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.SYNC_WORLD_STATE,
                client.uuid,
                acknowledgmentId,
                networkWorldStateSync
              );
              if (networkBuffer !== undefined) {
                this.networkHandler.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkBuffer,
                    [client],
                    PACKET_PRIORITY.HIGH
                  )
                );
                isPacketHandled = true;
              }
            }
            break;
          case MESSAGE_TYPE.DATA_PLAYER_SYNC:
            {
              // TODO: Sync player data within the instance

              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.DATA_PLAYER_SYNC,
                client.uuid,
                acknowledgmentId,
                undefined
              );
              if (networkBuffer !== undefined) {
                this.networkHandler.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkBuffer,
                    [client],
                    PACKET_PRIORITY.HIGH
                  )
                );
                isPacketHandled = true;
              }
            }
            break;
          case MESSAGE_TYPE.DATA_PLAYER_POSITION:
            {
              isPacketHandled = true;
            }
            break;
          case MESSAGE_TYPE.REQUEST_INSTANCE_LIST:
            {
              const instanceIds = this.instanceHandler
                .getInstanceIds()
                .filter(function (instanceId) {
                  return parseInt(instanceId) !== 0;
                });
              const instances = instanceIds.map((instanceId) => {
                let instance = this.instanceHandler.getInstance(instanceId);
                if (instance !== undefined) {
                  return {
                    instance_id: instanceId,
                    room_index: instance.roomIndex,
                    player_count: instance.getPlayerCount(),
                  };
                }
              });

              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.REQUEST_INSTANCE_LIST,
                client.uuid,
                acknowledgmentId,
                { available_instances: instances }
              );
              if (networkBuffer !== undefined) {
                this.networkHandler.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkBuffer,
                    [client],
                    PACKET_PRIORITY.DEFAULT
                  )
                );
                isPacketHandled = true;
              }
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
                  const networkBuffer = this.networkPacketBuilder.createPacket(
                    MESSAGE_TYPE.REQUEST_FAST_TRAVEL,
                    client.uuid,
                    acknowledgmentId,
                    payloadFastTravelInfo
                  );
                  if (networkBuffer !== undefined) {
                    this.networkHandler.packetQueue.enqueue(
                      new NetworkQueueEntry(
                        networkBuffer,
                        [client],
                        PACKET_PRIORITY.DEFAULT
                      )
                    );
                    isPacketHandled = true;
                  }
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
                  instance.containerHandler.initContainer(
                    containerId,
                    INVENTORY_TYPE.LOOT_CONTAINER
                  );
                }

                const networkBuffer = this.networkPacketBuilder.createPacket(
                  MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT,
                  client.uuid,
                  acknowledgmentId,
                  containerContentInfo
                );
                if (networkBuffer !== undefined) {
                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkBuffer,
                      [client],
                      PACKET_PRIORITY.DEFAULT
                    )
                  );
                  isPacketHandled = true;
                }
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
                  containerInventoryStream.targetInventory =
                    container.inventory;
                  instance.containerHandler.activeInventoryStream =
                    containerInventoryStream;

                  const networkBuffer = this.networkPacketBuilder.createPacket(
                    MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM,
                    client.uuid,
                    acknowledgmentId,
                    undefined
                  );
                  if (networkBuffer !== undefined) {
                    this.networkHandler.packetQueue.enqueue(
                      new NetworkQueueEntry(
                        networkBuffer,
                        [client],
                        PACKET_PRIORITY.DEFAULT
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
                        const networkBuffer =
                          this.networkPacketBuilder.createPacket(
                            MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
                            client.uuid,
                            acknowledgmentId,
                            undefined
                          );
                        if (networkBuffer !== undefined) {
                          this.networkHandler.packetQueue.enqueue(
                            new NetworkQueueEntry(
                              networkBuffer,
                              [client],
                              PACKET_PRIORITY.DEFAULT
                            )
                          );
                          isPacketHandled = true;
                        }
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

                      const networkBuffer =
                        this.networkPacketBuilder.createPacket(
                          MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
                          client.uuid,
                          acknowledgmentId,
                          inventoryStreamItems
                        );
                      if (networkBuffer !== undefined) {
                        this.networkHandler.packetQueue.enqueue(
                          new NetworkQueueEntry(
                            networkBuffer,
                            [client],
                            PACKET_PRIORITY.DEFAULT
                          )
                        );
                        isPacketHandled = true;
                      }
                    } else {
                      // TODO: Duplicate code with all MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM responses
                      const networkBuffer =
                        this.networkPacketBuilder.createPacket(
                          MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
                          client.uuid,
                          acknowledgmentId,
                          undefined
                        );
                      if (networkBuffer !== undefined) {
                        this.networkHandler.packetQueue.enqueue(
                          new NetworkQueueEntry(
                            networkBuffer,
                            [client],
                            PACKET_PRIORITY.DEFAULT
                          )
                        );
                        isPacketHandled = true;
                      }
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
                const networkBuffer = this.networkPacketBuilder.createPacket(
                  MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
                  client.uuid,
                  acknowledgmentId,
                  undefined
                );
                if (networkBuffer !== undefined) {
                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkBuffer,
                      [client],
                      PACKET_PRIORITY.DEFAULT
                    )
                  );
                  isPacketHandled = true;
                }
              } else {
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
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_ADD_ITEM,
                        client.uuid,
                        acknowledgmentId,
                        undefined
                      );
                    if (networkBuffer !== undefined) {
                      this.networkHandler.packetQueue.enqueue(
                        new NetworkQueueEntry(
                          networkBuffer,
                          [client],
                          PACKET_PRIORITY.DEFAULT
                        )
                      );
                      isPacketHandled = true;
                    }
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
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM,
                        client.uuid,
                        acknowledgmentId,
                        undefined
                      );
                    if (networkBuffer !== undefined) {
                      this.networkHandler.packetQueue.enqueue(
                        new NetworkQueueEntry(
                          networkBuffer,
                          [client],
                          PACKET_PRIORITY.DEFAULT
                        )
                      );
                      isPacketHandled = true;
                    }
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
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM,
                        client.uuid,
                        acknowledgmentId,
                        undefined
                      );
                    if (networkBuffer !== undefined) {
                      this.networkHandler.packetQueue.enqueue(
                        new NetworkQueueEntry(
                          networkBuffer,
                          [client],
                          PACKET_PRIORITY.DEFAULT
                        )
                      );
                      isPacketHandled = true;
                    }
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
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM,
                        client.uuid,
                        acknowledgmentId,
                        undefined
                      );
                    if (networkBuffer !== undefined) {
                      this.networkHandler.packetQueue.enqueue(
                        new NetworkQueueEntry(
                          networkBuffer,
                          [client],
                          PACKET_PRIORITY.DEFAULT
                        )
                      );
                      isPacketHandled = true;
                    }
                  }
                }
              }
            }
            break;
        }
      }
    }
    return isPacketHandled;
  }
}
