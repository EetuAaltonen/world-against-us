import BITWISE from "../constants/Bitwise.js";

const NULL_TERMINATOR = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.headerBuffer = Buffer.alloc(
      BITWISE.BIT8 + // Message Type
        BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 // Null Termination
    );
  }

  createPacket(messageType, clientId, payload) {
    let packet;
    this.writePacketHeader(messageType, clientId);

    // TODO: Write payload to buffer

    packet = Buffer.concat([this.headerBuffer /*+payloadBuffer*/]);
    return packet;
  }

  writePacketHeader(messageType, clientId) {
    // Response with a new Uuid and all player data
    this.headerBuffer.writeUInt8(messageType, 0, BITWISE.BIT8);
    this.headerBuffer.fill(
      clientId + NULL_TERMINATOR,
      BITWISE.BIT8,
      this.headerBuffer.length,
      "utf8"
    );
  }
}
