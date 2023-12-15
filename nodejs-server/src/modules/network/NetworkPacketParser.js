import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";

import Vector2 from "../math/Vector2.js";
import GridIndex from "../inventory/GridIndex.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import WorldMapFastTravelPoint from "../world_map/WorldMapFastTravelInfo.js";
import NetworkInventoryStream from "../network_inventory_stream/NetworkInventoryStream.js";
import NetworkInventoryStreamItems from "../network_inventory_stream/NetworkInventoryStreamItems.js";
import ContainerInventoryActionInfo from "../containers/ContainerInventoryActionInfo.js";
import PatrolState from "../patrols/PatrolState.js";
import NetworkPingSample from "../connection_sampling/NetworkPingSample.js";

import ParseJSONObjectsToArray from "../json/ParseJSONObjectsToArray.js";
import ParseJSONObjectToItemReplica from "../items/ParseJSONObjectToItemReplica.js";

export default class NetworkPacketParser {
  constructor() {}

  parsePacket(msg) {
    let offset = 0;
    const messageType = msg.readUInt8(offset);
    offset += BITWISE.BIT8;
    const clientId = msg.toString("utf8", offset, offset + BITWISE.ID_LENGTH);
    offset += BITWISE.ID_LENGTH;
    const sequenceNumber = msg.readUInt8(offset);
    offset += BITWISE.BIT8;
    const ackCount = msg.readUInt8(offset);
    offset += BITWISE.BIT8;

    const header = new NetworkPacketHeader(messageType, clientId);
    header.sequenceNumber = sequenceNumber;
    header.ackCount = ackCount;
    header.ackRange = [];
    for (let i = 0; i < ackCount; i++) {
      const acknowledgmentId = msg.readUInt8(offset);
      offset += BITWISE.BIT8;
      header.ackRange.push(acknowledgmentId);
    }

    // Slice header from buffer
    msg = msg.slice(offset);
    const payload = this.parsePayload(messageType, msg);
    const networkPacket = new NetworkPacket(header, payload);
    return networkPacket;
  }

  parsePayload(messageType, msg) {
    let payload;
    try {
      if (msg.length > 0) {
        switch (messageType) {
          case MESSAGE_TYPE.PING:
            {
              let offset = 0;
              const parsedClientTime = msg.readUInt32LE(offset);
              payload = new NetworkPingSample(parsedClientTime, 0);
            }
            break;
          case MESSAGE_TYPE.PONG:
            {
              let offset = 0;
              const parsedServerTime = msg.readUInt32LE(offset);
              payload = new NetworkPingSample(0, parsedServerTime);
            }
            break;
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
                parsedStreamItemLimit,
                parsedIsStreamSending,
                parsedStreamCurrentIndex,
                parsedStreamEndIndex
              );
            }
            break;
          case MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM:
            {
              const jsonString = msg.toString("utf8", 0, msg.length);
              const parsedJSONObject = JSON.parse(jsonString);
              if (!this.isObjectEmpty(parsedJSONObject)) {
                const jsonItems = parsedJSONObject["items"] ?? undefined;
                const parsedItems = ParseJSONObjectsToArray(
                  jsonItems,
                  ParseJSONObjectToItemReplica
                );
                payload = new NetworkInventoryStreamItems(parsedItems);
              } else {
                payload = parsedJSONObject;
              }
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
          case MESSAGE_TYPE.PATROL_STATE:
            {
              let offset = 0;
              const parsedInstanceId = msg.readUInt8(offset);
              offset += BITWISE.BIT32;
              const parsedPatrolId = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedAIState = msg.readUInt8(offset);
              payload = new PatrolState(
                parsedInstanceId,
                parsedPatrolId,
                parsedAIState
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

  isObjectEmpty(object) {
    return Object.keys(object).length === 0;
  }
}
