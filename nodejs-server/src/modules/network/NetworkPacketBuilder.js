import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";

const NULL_TERMINATOR = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.headerBuffer = Buffer.alloc(
      BITWISE.BIT8 + // Message Type
        BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 + // Null Termination
        BITWISE.BIT8 + // Sequence Number
        BITWISE.BIT8 // Acknowledgment ID
    );
    this.payloadBuffer = undefined;
  }

  createNetworkBuffer(networkPacket) {
    let networkBuffer;
    if (
      this.writePacketHeader(
        networkPacket.header.messageType,
        networkPacket.header.clientId,
        networkPacket.header.sequenceNumber,
        networkPacket.header.acknowledgmentId
      )
    ) {
      if (
        this.writePacketPayload(
          networkPacket.header.messageType,
          networkPacket.payload
        )
      ) {
        if (this.payloadBuffer !== undefined) {
          networkBuffer = Buffer.concat([
            this.headerBuffer,
            this.payloadBuffer,
          ]);
        } else {
          // Send networkBuffer without a payload
          networkBuffer = this.headerBuffer;
        }
      }
    }
    return networkBuffer;
  }

  writePacketHeader(messageType, clientId, sequenceNumber, acknowledgmentId) {
    let isPacketHeaderWritten = false;
    try {
      // Response with a new Uuid and all player data
      let offset = 0;
      this.headerBuffer.writeUInt8(messageType, offset);
      offset += BITWISE.BIT8;
      this.headerBuffer.fill(
        clientId + NULL_TERMINATOR,
        offset,
        offset + BITWISE.ID_LENGTH + BITWISE.BIT8,
        "utf8"
      );
      offset += BITWISE.ID_LENGTH + BITWISE.BIT8;
      this.headerBuffer.writeInt8(sequenceNumber, offset);
      offset += BITWISE.BIT8;
      this.headerBuffer.writeInt8(acknowledgmentId, offset);

      isPacketHeaderWritten = true;
    } catch (error) {
      throw error;
    }
    return isPacketHeaderWritten;
  }

  writePacketPayload(messageType, payload) {
    let isPayloadWritten = false;
    // Reset payload buffer
    this.payloadBuffer = undefined;
    if (payload !== undefined) {
      try {
        switch (messageType) {
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
