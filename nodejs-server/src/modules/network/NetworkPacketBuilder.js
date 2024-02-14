import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";

import zlib from "node:zlib";
import ConsoleHandler from "../console/ConsoleHandler.js";

const NULL_TERMINATOR = "\0";

export default class NetworkPacketBuilder {
  constructor() {
    this.headerBufferMessageType = Buffer.alloc(
      BITWISE.BIT8 // Message Type
    );
    this.headerBufferBase = Buffer.alloc(
      BITWISE.ID_LENGTH + // UUID
        BITWISE.BIT8 + // Null Terminator
        BITWISE.BIT8 + // Sequence Number
        BITWISE.BIT8 // Ack Count
    );
    this.headerBufferAckRange = undefined;
    this.payloadBuffer = undefined;
  }

  createNetworkBuffer(networkPacket) {
    let networkBuffer = undefined;
    try {
      if (networkPacket !== undefined) {
        if (this.writePacketHeader(networkPacket)) {
          if (this.writePacketPayload(networkPacket)) {
            if (!networkPacket.deliveryPolicy.minimalHeader) {
              networkBuffer = this.headerBufferBase;
              // Concat network buffer with ACK range buffer
              if (this.headerBufferAckRange !== undefined) {
                networkBuffer = Buffer.concat([
                  networkBuffer,
                  this.headerBufferAckRange,
                ]);
              }
              // Concat network buffer with payload buffer
              if (this.payloadBuffer !== undefined) {
                networkBuffer = Buffer.concat([
                  networkBuffer,
                  this.payloadBuffer,
                ]);
              }
            } else {
              // Use only payload
              networkBuffer = this.payloadBuffer;
            }

            if (networkBuffer !== undefined) {
              // Compress network buffer
              if (networkPacket.deliveryPolicy.compress) {
                networkBuffer = zlib.deflateSync(networkBuffer);
              }
              // Concat final network buffer
              networkBuffer = Buffer.concat([
                this.headerBufferMessageType,
                networkBuffer,
              ]);
            } else {
              networkBuffer = this.headerBufferMessageType;
            }
          }
        }
      }
    } catch (error) {
      console.log(error);
    }
    return networkBuffer;
  }

  writePacketHeader(networkPacket) {
    let isPacketHeaderWritten = false;
    try {
      // Write message type
      const messageType = networkPacket.header.messageType;
      this.headerBufferMessageType.writeUInt8(messageType, 0);

      // Reset header ack range buffer
      this.headerBufferAckRange = undefined;
      if (!networkPacket.deliveryPolicy.minimalHeader) {
        const clientId = networkPacket.header.clientId;
        const sequenceNumber = networkPacket.header.sequenceNumber;
        const ackCount = networkPacket.header.ackCount;
        const ackRange = networkPacket.header.ackRange;

        // Write client ID
        let offset = 0;
        this.headerBufferBase.fill(
          clientId + NULL_TERMINATOR,
          offset,
          offset + BITWISE.ID_LENGTH + BITWISE.BIT8,
          "utf8"
        );
        offset += BITWISE.ID_LENGTH + BITWISE.BIT8;
        // Write sequence number and ack count
        this.headerBufferBase.writeUInt8(sequenceNumber, offset);
        offset += BITWISE.BIT8;
        this.headerBufferBase.writeUInt8(ackCount, offset);

        if (ackCount > 0) {
          // Allocate ack range buffer
          this.headerBufferAckRange = Buffer.allocUnsafe(
            BITWISE.BIT8 * ackCount
          );
          let ackOffset = 0;
          for (let i = 0; i < ackCount; i++) {
            const acknowledgmentId = ackRange[i] ?? 0;
            this.headerBufferAckRange.writeUInt8(acknowledgmentId, ackOffset);
            ackOffset += BITWISE.BIT8;
          }
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
          case MESSAGE_TYPE.PING:
            {
              const bufferPing = Buffer.allocUnsafe(BITWISE.BIT32);
              bufferPing.writeUInt32LE(payload);
              this.payloadBuffer = bufferPing;
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REMOTE_CONNECTED_TO_HOST:
            {
              // TODO: Write single function to build payload from RemotePlayerInfo
              // that appears in almost every MESSAGE_TYPE.REMOTE_X...
              const bufferClientId = Buffer.from(
                payload.clientId + NULL_TERMINATOR,
                "utf8"
              );
              const bufferPlayerTag = Buffer.from(payload.playerTag, "utf8");
              this.payloadBuffer = Buffer.concat([
                bufferClientId,
                bufferPlayerTag,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REMOTE_DISCONNECT_FROM_HOST:
            {
              const bufferClientId = Buffer.from(
                payload.clientId + NULL_TERMINATOR,
                "utf8"
              );
              const bufferPlayerTag = Buffer.from(payload.playerTag, "utf8");
              this.payloadBuffer = Buffer.concat([
                bufferClientId,
                bufferPlayerTag,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.INVALID_REQUEST:
            {
              const bufferInvalidRequest = Buffer.allocUnsafe(
                BITWISE.BIT8 + BITWISE.BIT8
              );
              let offset = 0;
              bufferInvalidRequest.writeUInt8(payload.requestAction, offset);
              offset += BITWISE.BIT8;
              bufferInvalidRequest.writeUInt8(
                payload.originalMessageType,
                offset
              );
              const bufferInvalidRequestMessage = Buffer.from(
                payload.invalidationMessage,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferInvalidRequest,
                bufferInvalidRequestMessage,
              ]);
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
          case MESSAGE_TYPE.INSTANCE_SNAPSHOT_DATA:
            {
              isPayloadWritten = this.writeInstanceSnapshotBuffer(payload);
            }
            break;
          case MESSAGE_TYPE.REMOTE_ENTERED_THE_INSTANCE:
            {
              const bufferClientId = Buffer.from(
                payload.clientId + NULL_TERMINATOR,
                "utf8"
              );
              const bufferPlayerTag = Buffer.from(
                payload.playerTag + NULL_TERMINATOR,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferClientId,
                bufferPlayerTag,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REMOTE_DATA_MOVEMENT_INPUT:
            {
              let deviceInputCompress = 0;
              if (payload.device_input_movement.key_up)
                deviceInputCompress += 1;
              if (payload.device_input_movement.key_down)
                deviceInputCompress += 2;
              if (payload.device_input_movement.key_left)
                deviceInputCompress += 4;
              if (payload.device_input_movement.key_right)
                deviceInputCompress += 8;

              const bufferDeviceInputMovement = Buffer.allocUnsafe(
                BITWISE.BIT8
              );
              let offset = 0;
              bufferDeviceInputMovement.writeUInt8(deviceInputCompress, offset);

              const bufferPlayerNetworkId = Buffer.from(
                payload.network_id,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferDeviceInputMovement,
                bufferPlayerNetworkId,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REMOTE_LEFT_THE_INSTANCE:
            {
              const bufferClientId = Buffer.from(
                payload.clientId + NULL_TERMINATOR,
                "utf8"
              );
              const bufferPlayerTag = Buffer.from(payload.playerTag, "utf8");
              this.payloadBuffer = Buffer.concat([
                bufferClientId,
                bufferPlayerTag,
              ]);
              isPayloadWritten = true;
            }
            break;
          case MESSAGE_TYPE.REMOTE_RETURNED_TO_CAMP:
            {
              const bufferClientId = Buffer.from(
                payload.clientId + NULL_TERMINATOR,
                "utf8"
              );
              const bufferPlayerTag = Buffer.from(payload.playerTag, "utf8");
              this.payloadBuffer = Buffer.concat([
                bufferClientId,
                bufferPlayerTag,
              ]);
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
          case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
            {
              const bufferInstanceId = Buffer.allocUnsafe(BITWISE.BIT32);
              bufferInstanceId.writeUInt32LE(payload.instanceId, 0);
              const bufferInventoryId = Buffer.from(
                payload.inventoryId,
                "utf8"
              );
              this.payloadBuffer = Buffer.concat([
                bufferInstanceId,
                bufferInventoryId,
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
          case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
            {
              isPayloadWritten = this.writeInstanceSnapshotBuffer(payload);
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
        ConsoleHandler.Log(error);
        throw error;
      }
    } else {
      // Return true when payload is left empty without an error
      isPayloadWritten = true;
    }
    return isPayloadWritten;
  }

  writeInstanceSnapshotBuffer(payload) {
    let isBufferWritten = false;
    try {
      let offset = 0;
      const bufferSnapshotData = Buffer.allocUnsafe(
        BITWISE.BIT32 + BITWISE.BIT8 + BITWISE.BIT8
      );
      bufferSnapshotData.writeUInt32LE(payload.instanceId);
      offset += BITWISE.BIT32;
      const localPlayerCount = payload.localPlayerCount;
      bufferSnapshotData.writeUInt8(localPlayerCount, offset);
      offset += BITWISE.BIT8;
      const localPatrolCount = payload.localPatrolCount;
      bufferSnapshotData.writeUInt8(localPatrolCount, offset);

      this.payloadBuffer = bufferSnapshotData;

      let bufferLocalPlayerData = undefined;
      if (localPlayerCount > 0) {
        // Allocate local player data buffer
        bufferLocalPlayerData = Buffer.allocUnsafe(
          (BITWISE.ID_LENGTH + // Network ID
            BITWISE.BIT8 + // Null Terminator
            BITWISE.BIT32 + // X-position
            BITWISE.BIT32) * // X-position
            localPlayerCount // Multiplier
        );
        let plrDataOffset = 0;
        for (let i = 0; i < localPlayerCount; i++) {
          const playerData = payload.localPlayers[i];
          bufferLocalPlayerData.fill(
            playerData.networkId + NULL_TERMINATOR,
            plrDataOffset,
            plrDataOffset + BITWISE.ID_LENGTH + BITWISE.BIT8,
            "utf8"
          );
          plrDataOffset += BITWISE.ID_LENGTH + BITWISE.BIT8;

          bufferLocalPlayerData.writeUInt32LE(
            playerData.position.x,
            plrDataOffset
          );
          plrDataOffset += BITWISE.BIT32;
          bufferLocalPlayerData.writeUInt32LE(
            playerData.position.y,
            plrDataOffset
          );
          plrDataOffset += BITWISE.BIT32;
        }
      }
      let bufferLocalPatrolData = undefined;
      if (localPatrolCount > 0) {
        // Allocate local player data buffer
        bufferLocalPatrolData = Buffer.allocUnsafe(
          (BITWISE.BIT8 + // Patrol ID
            BITWISE.BIT16 + // Route progress
            BITWISE.BIT32 + // X-position
            BITWISE.BIT32) * // X-position
            localPatrolCount // Multiplier
        );
        let patrolDataOffset = 0;
        for (let i = 0; i < localPatrolCount; i++) {
          const patrol = payload.localPatrols[i];
          bufferLocalPatrolData.writeUInt8(patrol.patrolId, patrolDataOffset);
          patrolDataOffset += BITWISE.BIT8;
          const scaledRouteProgress = patrol.getScaledRouteProgress();
          bufferLocalPatrolData.writeUInt16LE(
            scaledRouteProgress,
            patrolDataOffset
          );
          patrolDataOffset += BITWISE.BIT16;
          bufferLocalPatrolData.writeUInt32LE(
            patrol.localPosition.x,
            patrolDataOffset
          );
          patrolDataOffset += BITWISE.BIT32;
          bufferLocalPatrolData.writeUInt32LE(
            patrol.localPosition.y,
            patrolDataOffset
          );
          patrolDataOffset += BITWISE.BIT32;
        }
      }

      if (bufferLocalPlayerData !== undefined) {
        this.payloadBuffer = Buffer.concat([
          this.payloadBuffer,
          bufferLocalPlayerData,
        ]);
      }
      if (bufferLocalPatrolData !== undefined) {
        this.payloadBuffer = Buffer.concat([
          this.payloadBuffer,
          bufferLocalPatrolData,
        ]);
      }
      isBufferWritten = true;
    } catch (error) {
      throw error;
    }
    return isBufferWritten;
  }
}
