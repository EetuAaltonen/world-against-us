import NetworkPacket from "./NetworkPacket.js";
import NetworkPacketHeader from "./NetworkPacketHeader.js";

import BITWISE from "./Bitwise.js";

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
    msg = msg.slice(BITWISE.ID_LENGTH + BITWISE.BIT8);
    const payload = this.parsePayload(messageType, msg);
    const networkPacket = new NetworkPacket(header, payload);

    return networkPacket;
  }

  parsePayload(messageType, msg) {
    let payload;
    switch (messageType) {
      default: {
        // No provided payload for an message type
        payload = {};
      }
    }
    return payload;
  }
}
