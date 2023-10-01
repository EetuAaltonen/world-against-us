import MESSAGE_TYPE from "../constants/MessageType.js";
import PACKET_PRIORITY from "../constants/PacketPriority.js";

import NetworkQueueEntry from "./NetworkQueueEntry.js";

export default class NetworkPacketHandler {
  constructor(networkHandler, networkPacketBuilder) {
    this.networkHandler = networkHandler;
    this.networkPacketBuilder = networkPacketBuilder;
  }

  handlePacket(clientId, networkPacket) {
    let isPacketHandled = false;
    if (networkPacket !== undefined) {
      switch (networkPacket.header.messageType) {
        case MESSAGE_TYPE.DATA_PLAYER_SYNC:
          {
            const client =
              this.networkHandler.clientHandler.getClient(clientId);
            // TODO: Sync player data within the instance

            const networkBuffer = this.networkPacketBuilder.createPacket(
              MESSAGE_TYPE.DATA_PLAYER_SYNC,
              clientId,
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
      }
    }
    return isPacketHandled;
  }
}
