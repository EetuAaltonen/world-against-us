import MESSAGE_TYPE from "../constants/MessageType.js";
import PACKET_PRIORITY from "../constants/PacketPriority.js";
import WorldMapFastTravelInfo from "../world_map/WorldMapFastTravelInfo.js";

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
                    fastTravelInfo.sourceInstanceId ===
                      fastTravelInfo.destinationInstanceId
                      ? undefined
                      : fastTravelInfo.destinationInstanceId
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
        }
      }
    }
    return isPacketHandled;
  }
}
