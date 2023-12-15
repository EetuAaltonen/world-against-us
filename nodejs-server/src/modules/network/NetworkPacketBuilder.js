import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";

const NULL_TERMINATOR = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.baseHeaderBuffer = Buffer.alloc(
      BITWISE.BIT8 + // Message Type
        BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 + // Null Termination
        BITWISE.BIT8 + // Sequence Number
        BITWISE.BIT8 // Ack Count
    );
    this.headerAckRangeBuffer = undefined;
    this.payloadBuffer = undefined;
  }

  createNetworkBuffer(networkPacket) {
    let networkBuffer;
    if (this.writePacketHeader(networkPacket)) {
      if (this.writePacketPayload(networkPacket)) {
        networkBuffer = this.baseHeaderBuffer;
        if (this.headerAckRangeBuffer !== undefined) {
          networkBuffer = Buffer.concat([
            networkBuffer,
            this.headerAckRangeBuffer,
          ]);
        }
        if (this.payloadBuffer !== undefined) {
          networkBuffer = Buffer.concat([networkBuffer, this.payloadBuffer]);
        }
      }
    }
    return networkBuffer;
  }

  writePacketHeader(networkPacket) {
    let isPacketHeaderWritten = false;
    const messageType = networkPacket.header.messageType;
    const clientId = networkPacket.header.clientId;
    const sequenceNumber = networkPacket.header.sequenceNumber;
    const ackCount = networkPacket.header.ackCount;
    const ackRange = networkPacket.header.ackRange;
    try {
      // Write message type and client ID
      let offset = 0;
      this.baseHeaderBuffer.writeUInt8(messageType, offset);
      offset += BITWISE.BIT8;
      this.baseHeaderBuffer.fill(
        clientId + NULL_TERMINATOR,
        offset,
        offset + BITWISE.ID_LENGTH + BITWISE.BIT8,
        "utf8"
      );
      offset += BITWISE.ID_LENGTH + BITWISE.BIT8;
      // Write sequence number and ack count
      this.baseHeaderBuffer.writeUInt8(sequenceNumber, offset);
      offset += BITWISE.BIT8;
      this.baseHeaderBuffer.writeUInt8(ackCount, offset);
      // Reset header ack range buffer
      this.headerAckRangeBuffer = undefined;
      if (ackCount > 0) {
        // Allocate ack range buffer
        this.headerAckRangeBuffer = Buffer.allocUnsafe(BITWISE.BIT8 * ackCount);
        let ackOffset = 0;
        for (let i = 0; i < ackCount; i++) {
          const acknowledgmentId = ackRange[i] ?? 0;
          this.headerAckRangeBuffer.writeUInt8(acknowledgmentId, ackOffset);
          ackOffset += BITWISE.BIT8;
        }
      }
      isPacketHeaderWritten = true;
    } catch (error) {
      throw error;
    }
    return isPacketHeaderWritten;
  }

  writePacketPayload(networkPacket) {
    let isPayloadWritten = false;
    const messageType = networkPacket.header.messageType;
    const payload = networkPacket.payload;
    // Reset payload buffer
    this.payloadBuffer = undefined;
    if (payload !== undefined) {
      try {
        switch (messageType) {
          case MESSAGE_TYPE.PONG:
            {
              const bufferPingPong = Buffer.allocUnsafe(
                BITWISE.BIT32 + BITWISE.BIT32
              );
              let offset = 0;
              bufferPingPong.writeUInt32LE(payload.clientTime, offset);
              offset += BITWISE.BIT32;
              bufferPingPong.writeUInt32LE(payload.serverTime, offset);
              this.payloadBuffer = bufferPingPong;
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER:
            {
              const bufferWeather = Buffer.allocUnsafe(BITWISE.BIT8);
              bufferWeather.writeUInt8(payload);
              this.payloadBuffer = bufferWeather;
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
            {
              const bufferInstanceIndices = Buffer.allocUnsafe(
                BITWISE.BIT32 + BITWISE.BIT32
              );
              bufferInstanceIndices.writeUInt32LE(payload.sourceInstanceId, 0);
              bufferInstanceIndices.writeUInt32LE(
                payload.destinationInstanceId,
                BITWISE.BIT32
              );
              const bufferDestinationRoomIndex = Buffer.from(
                payload.destinationRoomIndex,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferInstanceIndices,
                bufferDestinationRoomIndex,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
            {
              const bufferContainerInfo = Buffer.allocUnsafe(BITWISE.BIT32);
              bufferContainerInfo.writeInt32LE(payload.contentCount, 0);
              const bufferContainerId = Buffer.from(
                payload.containerId,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferContainerInfo,
                bufferContainerId,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.PATROL_STATE:
            {
              const bufferPatrol = Buffer.allocUnsafe(
                BITWISE.BIT32 + BITWISE.BIT8 + BITWISE.BIT8
              );
              bufferPatrol.writeUInt32LE(payload.instanceId, 0);
              bufferPatrol.writeUInt8(payload.patrolId, BITWISE.BIT32);
              bufferPatrol.writeUInt8(
                payload.aiState,
                BITWISE.BIT32 + BITWISE.BIT8
              );
              this.payloadBuffer = bufferPatrol;
              isPayloadWritten = true;
            }
            break;
          default: {
            this.payloadBuffer = Buffer.from(
              JSON.stringify(payload ?? {}),
              "utf8"
            );
            isPayloadWritten = true;
          }
        }
      } catch (error) {
        console.log(error);
        throw error;
      }
    } else {
      // Return true when payload is left empty without an error
      isPayloadWritten = true;
    }
    return isPayloadWritten;
  }
}
