import MESSAGE_TYPE from "./MessageType.js";

import ClientHandler from "../clients/ClientHandler.js";
import NetworkPacketParser from "./NetworkPacketParser.js";
import NetworkPacketBuilder from "./NetworkPacketBuilder.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkHandler {
  constructor() {
    this.packetParser = new NetworkPacketParser();
    this.packetBuilder = new NetworkPacketBuilder();
    this.clientHandler = new ClientHandler();
  }

  handlePacket(msg, rinfo, socket) {
    let isPacketHandled = false;
    const networkPacket = this.packetParser.parsePacket(msg, rinfo);
    const clientId = networkPacket.header.clientId;
    switch (networkPacket.header.messageType) {
      case MESSAGE_TYPE.CONNECT_TO_HOST:
        {
          if (clientId === UNDEFINED_UUID) {
            // Generate new Uuid and save client
            const newClientId = this.clientHandler.connectClient(rinfo);

            const networkBuffer = this.packetBuilder.createPacket(
              MESSAGE_TYPE.CONNECT_TO_HOST,
              newClientId,
              undefined
            );
            socket.send(networkBuffer, rinfo.port, rinfo.address);

            isPacketHandled = true;
          }
        }
        break;
      case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
        {
          this.clientHandler.disconnectClient(clientId, rinfo);
        }
        break;
    }
    return isPacketHandled;
  }
}
