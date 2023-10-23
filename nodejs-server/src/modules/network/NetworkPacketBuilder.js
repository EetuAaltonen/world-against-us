import BITWISE from "../constants/Bitwise.js";

const NULL_TERMINATOR = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.headerBuffer = Buffer.alloc(
      BITWISE.BIT8 + // Message Type
        BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 + // Null Termination
        BITWISE.BIT8 // Acknowledgment ID
    );
  }

  createPacket(messageType, clientId, acknowledgmentId, payload) {
    let packet;
    this.writePacketHeader(messageType, clientId, acknowledgmentId);

    // TODO: Write payload to buffer

    packet = Buffer.concat([this.headerBuffer /*+payloadBuffer*/]);
    return packet;
  }

  writePacketHeader(messageType, clientId, acknowledgmentId) {
    // Response with a new Uuid and all player data
    this.headerBuffer.writeUInt8(messageType, 0);
    this.headerBuffer.fill(
      clientId + NULL_TERMINATOR,
      BITWISE.BIT8,
      this.headerBuffer.length - BITWISE.BIT8,
      "utf8"
    );
    this.headerBuffer.writeInt8(
      acknowledgmentId,
      this.headerBuffer.length - BITWISE.BIT8
    );
  }
}
