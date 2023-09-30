import BITWISE from "../constants/Bitwise.js";
import MESSAGE_TYPE from "../constants/MessageType.js";
import Vector2 from "../math/Vector2.js";

import NetworkPacket from "./NetworkPacket.js";
import NetworkPacketHeader from "./NetworkPacketHeader.js";

export default class NetworkPacketParser {
  constructor() {}
  parsePacket(msg) {
    const messageType = msg.readUInt8(0);
    const clientId = msg.toString(
      "utf8",
      BITWISE.BIT8,
      BITWISE.ID_LENGTH + BITWISE.BIT8
    );
    const header = new NetworkPacketHeader(messageType, clientId);
    // Slice header from buffer
    msg = msg.slice(
      BITWISE.ID_LENGTH + // Client ID
        BITWISE.BIT8 // Message type
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
              const xPos = msg.readUInt32LE(offset);
              offset += BITWISE.BIT32;
              const yPos = msg.readUInt32LE(offset);
              const position = new Vector2(xPos, yPos);

              // TODO: Update player position
            }
            break;
          default: {
            // Default payload is JSON
            const jsonString = msg.toString("utf8", 0, msg.length);
            payload = JSON.parse(jsonString);
            console.log(payload);
          }
        }
      }
    } catch (error) {
      console.log(error);
    }
    return payload;
  }
}
