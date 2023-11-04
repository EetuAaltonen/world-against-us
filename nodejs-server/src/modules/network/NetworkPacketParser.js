import BITWISE from "../constants/Bitwise.js";
import MESSAGE_TYPE from "../constants/MessageType.js";

import Vector2 from "../math/Vector2.js";

import NetworkPacket from "./NetworkPacket.js";
import NetworkPacketHeader from "./NetworkPacketHeader.js";
import WorldMapFastTravelPoint from "../world_map/WorldMapFastTravelInfo.js";
import NetworkInventoryStream from "../inventory/NetworkInventoryStream.js";
import ContainerInventoryActionInfo from "../containers/ContainerInventoryActionInfo.js";
import GridIndex from "../inventory/GridIndex.js";

export default class NetworkPacketParser {
  constructor() {}

  parsePacket(msg) {
    const messageType = msg.readUInt8(0);
    const clientId = msg.toString(
      "utf8",
      BITWISE.BIT8,
      BITWISE.BIT8 + BITWISE.ID_LENGTH
    );
    const acknowledgmentId = msg.readInt8(BITWISE.BIT8 + BITWISE.ID_LENGTH);
    const header = new NetworkPacketHeader(
      messageType,
      clientId,
      acknowledgmentId
    );
    // Slice header from buffer
    msg = msg.slice(
      BITWISE.ID_LENGTH + // Client ID
        BITWISE.BIT8 + // Message type
        BITWISE.BIT8 // Acknowledgment ID
    );
    const payload = this.parsePayload(messageType, msg);
    const networkPacket = new NetworkPacket(header, payload);

    return networkPacket;
  }

  parsePayload(messageType, msg) {
    let payload;
    try {
      if (msg.length > 0) {
        switch (messageType) {
          case MESSAGE_TYPE.DATA_PLAYER_POSITION:
            {
              let offset = 0;
              const parsedXPos = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedYPos = msg.readUInt32LE(offset);
              payload = new Vector2(parsedXPos, parsedYPos);
            }
            break;
          case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
            {
              let offset = 0;
              const parsedSourceInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedDestinationInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedRoomIndex = msg.toString("utf8", offset);
              payload = new WorldMapFastTravelPoint(
                parsedSourceInstanceId,
                parsedDestinationInstanceId,
                parsedRoomIndex
              );
            }
            break;
          case MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT:
            {
              let offset = 0;
              payload = msg.toString("utf8", offset);
            }
            break;
          case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
            {
              let offset = 0;
              const parsedInstancePosX = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedInstancePosY = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedStreamItemLimit = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedIsStreamSending = Boolean(msg.readUInt8(offset));
              offset += BITWISE.BIT8;
              const parsedStreamCurrentIndex = msg.readUInt16LE(offset);
              offset += BITWISE.BIT16;
              const parsedStreamEndIndex = msg.readUInt16LE(offset);
              offset += BITWISE.BIT16;
              const parsedContainerId = msg.toString("utf8", offset);
              payload = new NetworkInventoryStream(
                parsedContainerId,
                new Vector2(parsedInstancePosX, parsedInstancePosY),
                parsedStreamItemLimit,
                parsedIsStreamSending,
                parsedStreamCurrentIndex,
                parsedStreamEndIndex
              );
            }
            break;
          case MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM:
            {
              let offset = 0;
              const parsedSourceGridIndexCol = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedSourceGridIndexRow = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedIsKnown = Boolean(msg.readUInt8(offset));
              offset += BITWISE.BIT8;
              const parsedContainerId = msg.toString("utf8", offset);

              const parsedSourceGridIndex = new GridIndex(
                parsedSourceGridIndexCol,
                parsedSourceGridIndexRow
              );

              payload = new ContainerInventoryActionInfo(
                parsedContainerId,
                parsedSourceGridIndex,
                undefined,
                undefined,
                parsedIsKnown,
                undefined
              );
            }
            break;
          case MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM:
            {
              let offset = 0;
              const parsedSourceGridIndexCol = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedSourceGridIndexRow = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedIsRotated = Boolean(msg.readUInt8(offset));
              offset += BITWISE.BIT8;
              const parsedContainerId = msg.toString("utf8", offset);

              const parsedSourceGridIndex = new GridIndex(
                parsedSourceGridIndexCol,
                parsedSourceGridIndexRow
              );

              payload = new ContainerInventoryActionInfo(
                parsedContainerId,
                parsedSourceGridIndex,
                undefined,
                parsedIsRotated,
                undefined,
                undefined
              );
            }
            break;
          case MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM:
            {
              let offset = 0;
              const parsedSourceGridIndexCol = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedSourceGridIndexRow = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedContainerId = msg.toString("utf8", offset);

              const parsedSourceGridIndex = new GridIndex(
                parsedSourceGridIndexCol,
                parsedSourceGridIndexRow
              );

              payload = new ContainerInventoryActionInfo(
                parsedContainerId,
                parsedSourceGridIndex,
                undefined,
                undefined,
                undefined,
                undefined
              );
            }
            break;
          default: {
            // Default JSON payload parsing
            const jsonString = msg.toString("utf8", 0, msg.length);
            payload = JSON.parse(jsonString);
          }
        }
      }
    } catch (error) {
      console.log(error);
    }
    return payload;
  }
}
