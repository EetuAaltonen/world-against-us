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
    this.payloadBuffer = undefined;
  }

  createPacket(messageType, clientId, acknowledgmentId, payload) {
    let packet;
    if (this.writePacketHeader(messageType, clientId, acknowledgmentId)) {
      if (this.writePacketPayload(payload)) {
        if (this.payloadBuffer !== undefined) {
          packet = Buffer.concat([this.headerBuffer, this.payloadBuffer]);
        }
      }
      this.payloadBuffer = undefined;
    }
    return packet;
  }

  writePacketHeader(messageType, clientId, acknowledgmentId) {
    let isPacketHeaderWritten = false;
    try {
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

      isPacketHeaderWritten = true;
    } catch (error) {
      throw error;
    }
    return isPacketHeaderWritten;
  }

  writePacketPayload(payload) {
    let isPacketPayloadWritten = false;
    try {
      this.payloadBuffer = Buffer.from(JSON.stringify(payload ?? {}), "utf8");
      isPacketPayloadWritten = true;
    } catch (error) {
      throw error;
    }
    return isPacketPayloadWritten;
  }
}
