import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";

import NetworkPacket from "./NetworkPacket.js";

const NULL_TERMINATION = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.headerBuffer = Buffer.alloc(
      BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 + // Null Termination
        BITWISE.BIT8 // Message Type
    );
  }

  writePacketHeader(messageType, clientId) {
    // Response with a new Uuid and all player data
    this.headerBuffer.writeUInt8(messageType, 0, BITWISE.BIT8);

    this.headerBuffer.fill(
      clientId + NULL_TERMINATION,
      BITWISE.BIT8,
      this.headerBuffer.length,
      "utf8"
    );
  }

  createPacket(messageType, clientId, payload) {
    let packet;
    this.writePacketHeader(messageType, clientId);

    // TODO: Write payload to buffer

    packet = Buffer.concat([this.headerBuffer /*+payloadBuffer*/]);
    return packet;
  }
}
