import BITWISE from "./Bitwise.js";
import MESSAGE_TYPE from "./MessageType.js";
import DELIVERY_POLICIES from "../network_packets/NetworkPacketDeliveryPolicies.js";

import zlib from "node:zlib";
import ConsoleHandler from "../console/ConsoleHandler.js";
import Vector2 from "../math/Vector2.js";
import GridIndex from "../inventory/GridIndex.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import WorldMapFastTravelPoint from "../world_map/WorldMapFastTravelInfo.js";
import InventoryStream from "../inventory/InventoryStream.js";
import InventoryStreamItems from "../inventory/InventoryStreamItems.js";
import ContainerInventoryActionInfo from "../containers/ContainerInventoryActionInfo.js";
import PatrolState from "../patrols/PatrolState.js";
import DeviceInputMovement from "../device_input/DeviceInputMovement.js";
import ScoutingDrone from "../operations_center/ScoutingDrone.js";
// TODO: Check these data structs (snake cased classes)

import ParseJSONStructToInventoryStreamItems from "../inventory/ParseJSONStructToInventoryStreamItems.js";

export default class NetworkPacketParser {
  constructor() {}

  parsePacket(msgRaw) {
    let networkPacket = undefined;
    try {
      let offset = 0;
      const messageType = msgRaw.readUInt8(offset);
      offset += BITWISE.BIT8;
      const header = new NetworkPacketHeader(messageType, undefined);
      const deliveryPolicy =
        DELIVERY_POLICIES[messageType] ??
        DELIVERY_POLICIES[MESSAGE_TYPE.LENGTH];

      let msg = msgRaw;
      if (deliveryPolicy.compress) {
        const compressMsg = msgRaw.subarray(offset);
        // Decompress message buffer
        msg = zlib.inflateSync(compressMsg);
        // Reset offset
        offset = 0;
      }

      if (Buffer.isBuffer(msg)) {
        // Parse Header
        if (!deliveryPolicy.minimalHeader) {
          const clientId = msg.toString(
            "utf8",
            offset,
            offset + BITWISE.ID_LENGTH
          );
          offset += BITWISE.ID_LENGTH;
          const sequenceNumber = msg.readUInt8(offset);
          offset += BITWISE.BIT8;
          const ackCount = msg.readUInt8(offset);
          offset += BITWISE.BIT8;

          header.clientId = clientId;
          header.sequenceNumber = sequenceNumber;
          header.ackCount = ackCount;
          header.ackRange = [];
          for (let i = 0; i < ackCount; i++) {
            const acknowledgmentId = msg.readUInt8(offset);
            offset += BITWISE.BIT8;
            header.ackRange.push(acknowledgmentId);
          }
        }

        // Parse payload
        const payload = this.parsePayload(messageType, msg, offset);
        networkPacket = new NetworkPacket(header, payload);
      }
    } catch (error) {
      console.log(error);
    }
    return networkPacket;
  }

  parsePayload(messageType, msg, offset) {
    let payload;
    try {
      if (offset < msg.length) {
        switch (messageType) {
          case MESSAGE_TYPE.CONNECT_TO_HOST:
            {
              const parsedPlayerTag = msg.toString("utf8", offset);
              payload = parsedPlayerTag;
            }
            break;
          case MESSAGE_TYPE.PING:
            {
              const clientTime = msg.readUInt32LE(offset);
              payload = clientTime;
            }
            break;
          case MESSAGE_TYPE.PLAYER_DATA_POSITION:
            {
              const parsedXPos = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedYPos = msg.readUInt32LE(offset);
              payload = new Vector2(parsedXPos, parsedYPos);
            }
            break;
          case MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT:
            {
              let parsedDeviceInputCompress = msg.readUInt8(offset);
              const parsedKeyRight = parsedDeviceInputCompress >= 8;
              if (parsedKeyRight) parsedDeviceInputCompress -= 8;
              const parsedKeyLeft = parsedDeviceInputCompress >= 4;
              if (parsedKeyLeft) parsedDeviceInputCompress -= 4;
              const parsedKeyDown = parsedDeviceInputCompress >= 2;
              if (parsedKeyDown) parsedDeviceInputCompress -= 2;
              const parsedKeyUp = parsedDeviceInputCompress >= 1;
              if (parsedKeyUp) parsedDeviceInputCompress -= 1;
              payload = new DeviceInputMovement(
                parsedKeyUp,
                parsedKeyDown,
                parsedKeyLeft,
                parsedKeyRight
              );
            }
            break;
          case MESSAGE_TYPE.REQUEST_FAST_TRAVEL:
            {
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
              const parsedInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedContainerId = msg.toString("utf8", offset);
              payload = {
                instanceId: parsedInstanceId,
                containerId: parsedContainerId,
              };
            }
            break;
          case MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM:
            {
              const parsedStreamItemLimit = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedIsStreamSending = Boolean(msg.readUInt8(offset));
              offset += BITWISE.BIT8;
              const parsedStreamCurrentIndex = msg.readUInt16LE(offset);
              offset += BITWISE.BIT16;
              const parsedStreamEndIndex = msg.readUInt16LE(offset);
              offset += BITWISE.BIT16;
              const parsedContainerId = msg.toString("utf8", offset);
              payload = new InventoryStream(
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
              const jsonString = msg.toString("utf8", offset);
              const jsonStruct = JSON.parse(jsonString);
              payload = ParseJSONStructToInventoryStreamItems(jsonStruct);
            }
            break;
          case MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM:
            {
              const parsedInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedInventoryId = msg.toString("utf8", offset);
              payload = new InventoryStreamItems(
                parsedInstanceId,
                parsedInventoryId,
                []
              );
            }
            break;
          case MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM:
            {
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
          case MESSAGE_TYPE.RELEASE_CONTAINER_CONTENT:
            {
              const parsedInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedContainerId = msg.toString("utf8", offset);
              payload = {
                instanceId: parsedInstanceId,
                containerId: parsedContainerId,
              };
            }
            break;
          case MESSAGE_TYPE.PATROL_STATE:
            {
              const parsedInstanceId = msg.readUInt32LE(offset);
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
          case MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA:
            {
              const parsedInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedPatrolCount = msg.readUInt8(offset);
              offset += BITWISE.BIT8;
              const parsedPatrols = [];
              for (let i = 0; i < parsedPatrolCount; i++) {
                const parsedPatrolId = msg.readUInt8(offset);
                offset += BITWISE.BIT8;
                const parsedRouteProgress = msg.readUInt16LE(offset);
                offset += BITWISE.BIT16;
                const parsedPositionX = msg.readUInt32LE(offset);
                offset += BITWISE.BIT32;
                const parsedPositionY = msg.readUInt32LE(offset);
                offset += BITWISE.BIT32;
                parsedPatrols.push({
                  patrol_id: parsedPatrolId,
                  route_progress: parsedRouteProgress,
                  position_x: parsedPositionX,
                  position_y: parsedPositionY,
                });
              }
              payload = {
                instance_id: parsedInstanceId,
                local_patrols: parsedPatrols,
              };
            }
            break;
          case MESSAGE_TYPE.START_OPERATIONS_SCOUT_STREAM:
            {
              payload = msg.readUInt32LE(offset);
            }
            break;
          case MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM:
            {
              const parsedInstanceId = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedXPos = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const parsedYPos = msg.readUInt32LE(offset);
              const parsedScoutingDrone = new ScoutingDrone(parsedInstanceId);
              parsedScoutingDrone.position.x = parsedXPos;
              parsedScoutingDrone.position.y = parsedYPos;
              payload = parsedScoutingDrone;
            }
            break;
          case MESSAGE_TYPE.END_OPERATIONS_SCOUT_STREAM:
            {
              payload = msg.readUInt32LE(offset);
            }
            break;
          default: {
            // Default JSON payload parsing
            const jsonString = msg.toString("utf8", offset);
            payload = JSON.parse(jsonString);
          }
        }
      }
    } catch (error) {
      console.log(error);
      ConsoleHandler.Log(error);
    }
    return payload;
  }

  isObjectEmpty(object) {
    return Object.keys(object).length === 0;
  }
}
