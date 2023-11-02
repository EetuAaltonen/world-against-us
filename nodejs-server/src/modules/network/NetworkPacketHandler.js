import MESSAGE_TYPE from "../constants/MessageType.js";
import PACKET_PRIORITY from "../constants/PacketPriority.js";

import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";
import ParseJSONObjectToItem from "../items/ParseJSONObjectToItemReplica.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";

export default class NetworkPacketHandler {
  constructor(networkHandler, networkPacketBuilder, instanceHandler) {
    this.networkHandler = networkHandler;
    this.networkPacketBuilder = networkPacketBuilder;
    this.instanceHandler = instanceHandler;
  }

  handlePacket(clientId, networkPacket) {
    let isPacketHandled = false;
    if (networkPacket !== undefined) {
      const client = this.networkHandler.clientHandler.getClient(clientId);
      if (client !== undefined) {
        const acknowledgmentId = networkPacket.header.acknowledgmentId;
        switch (networkPacket.header.messageType) {
          case MESSAGE_TYPE.DATA_PLAYER_SYNC:
            {
              // TODO: Sync player data within the instance

              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.DATA_PLAYER_SYNC,
                clientId,
                acknowledgmentId,
                undefined
              );
              this.networkHandler.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkBuffer,
                  [client],
                  PACKET_PRIORITY.HIGH
                )
              );
              isPacketHandled = true;
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
                clientId,
                acknowledgmentId,
                { available_instances: instances }
              );

              this.networkHandler.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkBuffer,
                  [client],
                  PACKET_PRIORITY.DEFAULT
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
                    clientId,
                    fastTravelInfo.sourceInstanceId,
                    fastTravelInfo.destinationRoomIndex,
                    fastTravelInfo.destinationInstanceId
                  );
                const destinationInstance = this.instanceHandler.getInstance(
                  destinationInstanceId
                );
                const payloadFastTravelInfo = new WorldMapFastTravelInfo(
                  fastTravelInfo.sourceInstanceId,
                  destinationInstanceId,
                  destinationInstance.roomIndex
                );
                const networkBuffer = this.networkPacketBuilder.createPacket(
                  MESSAGE_TYPE.REQUEST_FAST_TRAVEL,
                  clientId,
                  acknowledgmentId,
                  payloadFastTravelInfo
                );

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
          case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
            {
              // TODO: Return a flag if container is already in-use by a player
              const containerContentInfo = networkPacket.payload;
              const instance = this.instanceHandler.getInstance(
                containerContentInfo.instanceId
              );
              if (instance !== undefined) {
                const container = instance.objectHandler.container;
                if (container === undefined) {
                  instance.initContainer();
                  containerContentInfo.contentCount = -1;
                } else {
                  const contentCount = instance.getContainerContentCount();
                  if (contentCount !== undefined) {
                    containerContentInfo.contentCount = contentCount;
                  }
                }
              }

              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT,
                clientId,
                acknowledgmentId,
                containerContentInfo
              );

              this.networkHandler.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkBuffer,
                  [client],
                  PACKET_PRIORITY.DEFAULT
                )
              );
              isPacketHandled = true;
            }
            break;
          case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
            {
              const containerInventoryStream = networkPacket.payload;
              const instance = this.instanceHandler.getInstance(
                containerInventoryStream.instanceId
              );
              if (instance !== undefined) {
                containerInventoryStream.targetInventory =
                  instance.objectHandler.container;
                instance.objectHandler.activeInventoryStream =
                  containerInventoryStream;

                const networkBuffer = this.networkPacketBuilder.createPacket(
                  MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM,
                  clientId,
                  acknowledgmentId,
                  undefined
                );

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
          case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
            {
              const containerInventoryStream = networkPacket.payload;
              const instance = this.instanceHandler.getInstance(
                containerInventoryStream.region_id
              );
              if (instance !== undefined) {
                const activeInventoryStream =
                  instance.objectHandler.activeInventoryStream;
                if (activeInventoryStream.isStreamSending) {
                  if (containerInventoryStream.items !== undefined) {
                    const parsedContainerItems =
                      containerInventoryStream.items.map((jsonItem) => {
                        return ParseJSONObjectToItem(jsonItem);
                      });
                    instance.addContainerItems(parsedContainerItems);
                    console.log(
                      `Container item count: ${
                        Object.keys(instance.objectHandler.container).length
                      }`
                    );

                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
                        clientId,
                        acknowledgmentId,
                        undefined
                      );

                    this.networkHandler.packetQueue.enqueue(
                      new NetworkQueueEntry(
                        networkBuffer,
                        [client],
                        PACKET_PRIORITY.DEFAULT
                      )
                    );
                  }
                } else {
                  let items = [];
                  const activeInventoryStream =
                    instance.objectHandler.activeInventoryStream;
                  if (activeInventoryStream !== undefined) {
                    items = activeInventoryStream.FetchItemsToStream();
                    console.log(`Fetched item count: ${items.length}`);
                  }
                  if (items.length > 0) {
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM,
                        clientId,
                        acknowledgmentId,
                        {
                          // TODO: Create own struct for inventory data stream
                          region_id: containerInventoryStream.instanceId,
                          items: items,
                        }
                      );

                    this.networkHandler.packetQueue.enqueue(
                      new NetworkQueueEntry(
                        networkBuffer,
                        [client],
                        PACKET_PRIORITY.DEFAULT
                      )
                    );
                  } else {
                    const networkBuffer =
                      this.networkPacketBuilder.createPacket(
                        MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
                        clientId,
                        acknowledgmentId,
                        undefined
                      );

                    this.networkHandler.packetQueue.enqueue(
                      new NetworkQueueEntry(
                        networkBuffer,
                        [client],
                        PACKET_PRIORITY.DEFAULT
                      )
                    );
                  }
                }
                isPacketHandled = true;
              }
            }
            break;
          case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
            {
              const containerInventoryStream = networkPacket.payload;
              const instance = this.instanceHandler.getInstance(
                containerInventoryStream.region_id
              );
              if (instance !== undefined) {
                const activeInventoryStream =
                  instance.objectHandler.activeInventoryStream;

                if (activeInventoryStream.isStreamSending) {
                  const networkBuffer = this.networkPacketBuilder.createPacket(
                    MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM,
                    clientId,
                    acknowledgmentId,
                    undefined
                  );

                  this.networkHandler.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkBuffer,
                      [client],
                      PACKET_PRIORITY.DEFAULT
                    )
                  );
                }
                isPacketHandled = true;
              }
            }
            break;
        }
      }
    }
    return isPacketHandled;
  }
}
