import MESSAGE_TYPE from "../constants/MessageType.js";

import ClientHandler from "../clients/ClientHandler.js";
import NetworkPacketParser from "./NetworkPacketParser.js";
import NetworkPacketBuilder from "./NetworkPacketBuilder.js";
import InstanceHandler from "../instances/InstanceHandler.js";
import Player from "../players/Player.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkHandler {
  constructor() {
    this.packetParser = new NetworkPacketParser();
    this.packetBuilder = new NetworkPacketBuilder();
    this.clientHandler = new ClientHandler();
    this.instanceHandler = new InstanceHandler();
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
      case MESSAGE_TYPE.REQUEST_JOIN_GAME:
        {
          if (clientId !== UNDEFINED_UUID) {
            const player = new Player(`Player_${clientId}`);
            const instanceId = this.instanceHandler.addPlayerToDefaultInstance(
              clientId,
              player
            );

            const networkBuffer = this.packetBuilder.createPacket(
              MESSAGE_TYPE.REQUEST_JOIN_GAME,
              clientId,
              undefined /*instanceId*/
            );
            socket.send(networkBuffer, rinfo.port, rinfo.address);

            isPacketHandled = true;
          }
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_SYNC:
        {
          if (clientId !== UNDEFINED_UUID) {
            // TODO: Sync player data within the instance

            const networkBuffer = this.packetBuilder.createPacket(
              MESSAGE_TYPE.DATA_PLAYER_SYNC,
              clientId,
              undefined
            );
            socket.send(networkBuffer, rinfo.port, rinfo.address);

            isPacketHandled = true;
          }
        }
        break;
      case MESSAGE_TYPE.DATA_PLAYER_POSITION:
        {
          if (clientId !== UNDEFINED_UUID) {
            if (networkPacket.payload !== undefined) {
            }

            isPacketHandled = true;
          }
        }
        break;
      case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
        {
          if (this.clientHandler.disconnectClient(clientId, rinfo)) {
            if (!this.instanceHandler.removePlayerFromInstance(clientId)) {
              // TODO: Proper error handling
              console.log(
                `Failed to remove a client with ID: ${clientId} from any instance`
              );
            }
          } else {
            // TODO: Proper error handling
            console.log(`Failed to disconnect a client with ID: ${clientId}`);
          }
        }
        break;
    }
    return isPacketHandled;
  }
}
