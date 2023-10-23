import PriorityQueuePkg from "@datastructures-js/priority-queue";

import MESSAGE_TYPE from "../constants/MessageType.js";
import PACKET_PRIORITY from "../constants/PacketPriority.js";

import ClientHandler from "../clients/ClientHandler.js";
import NetworkPacketParser from "./NetworkPacketParser.js";
import NetworkPacketHandler from "./NetworkPacketHandler.js";
import NetworkPacketBuilder from "./NetworkPacketBuilder.js";
import NetworkQueueEntry from "./NetworkQueueEntry.js";
import InstanceHandler from "../instances/InstanceHandler.js";
import Player from "../players/Player.js";

// TODO: Try adjust server send rate to near 50hz
const PERFECT_TICK_TIME = 1000 / 50;
const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkHandler {
  constructor(socket) {
    this.socket = socket;

    this.packetQueue = new PriorityQueuePkg.PriorityQueue((a, b) => {
      return a.priority > b.priority ? -1 : 1;
    });

    this.networkPacketParser = new NetworkPacketParser();
    this.networkPacketBuilder = new NetworkPacketBuilder();
    this.clientHandler = new ClientHandler();
    this.instanceHandler = new InstanceHandler();

    this.networkPacketHandler = new NetworkPacketHandler(
      this,
      this.networkPacketBuilder
    );
  }

  async update() {
    try {
      const startTime = process.hrtime();

      const queuePacket = this.packetQueue.dequeue();
      if (queuePacket != undefined) {
        console.log(
          `Network packet size: ${queuePacket.packet.length * 0.001}kb`
        );
        queuePacket.clients.forEach((client) => {
          this.socket.send(queuePacket.packet, client.port, client.address);
        });
      }

      const endTime = process.hrtime(startTime);
      const timeInMs = endTime[0] * 1000 + endTime[1] / 1000000;
      const sleepTime = PERFECT_TICK_TIME - timeInMs;
      if (sleepTime >= 0) {
        await sleep(sleepTime);
      } else {
        console.log(`Server is lagging behind ${sleepTime}ms`);
      }
    } catch (error) {
      this.onError(error);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
    }
  }

  handleMessage(msg, rinfo) {
    try {
      let isMessageHandled = false;
      const networkPacket = this.networkPacketParser.parsePacket(msg, rinfo);
      const clientId = networkPacket.header.clientId;
      const acknowledgmentId = networkPacket.header.acknowledgmentId;

      switch (networkPacket.header.messageType) {
        case MESSAGE_TYPE.CONNECT_TO_HOST:
          {
            if (clientId === UNDEFINED_UUID) {
              // Generate new Uuid and save client
              const newClientId = this.clientHandler.connectClient(rinfo);
              const client = this.clientHandler.getClient(newClientId);
              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.CONNECT_TO_HOST,
                newClientId,
                acknowledgmentId,
                undefined
              );

              this.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkBuffer,
                  [client],
                  PACKET_PRIORITY.HIGH
                )
              );
              isMessageHandled = true;
            }
          }
          break;
        case MESSAGE_TYPE.REQUEST_JOIN_GAME:
          {
            if (clientId !== UNDEFINED_UUID) {
              const client = this.clientHandler.getClient(clientId);
              const player = new Player(`Player_${clientId}`);
              const instanceId =
                this.instanceHandler.addPlayerToDefaultInstance(
                  clientId,
                  player
                );
              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.REQUEST_JOIN_GAME,
                clientId,
                acknowledgmentId,
                undefined /*instanceId*/
              );

              this.packetQueue.enqueue(
                new NetworkQueueEntry(
                  networkBuffer,
                  [client],
                  PACKET_PRIORITY.HIGH
                )
              );
              isMessageHandled = true;
            }
          }
          break;
        case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
          {
            if (this.clientHandler.disconnectClient(clientId, rinfo)) {
              isMessageHandled = true;
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
        default: {
          isMessageHandled = this.networkPacketHandler.handlePacket(
            clientId,
            networkPacket
          );
        }
      }
      return isMessageHandled;
    } catch (error) {
      this.onError(error);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
    }
  }

  broadCast(networkBuffer) {
    throw new Error("Not implemented");

    /*this.packetQueue.enqueue(
      new NetworkQueueEntry(
        networkBuffer,
        rinfo.port,
        rinfo.address,
        PACKET_PRIORITY.HIGH
      )
    );*/
  }

  onError(error) {
    try {
      console.log(`server error:\n${error.stack}`);
      const allClients = this.clientHandler.getAllClients();
      const networkBuffer = this.networkPacketBuilder.createPacket(
        MESSAGE_TYPE.SERVER_ERROR,
        -1,
        undefined,
        {
          error: "Internal Server Error. Disconnecting...",
        }
      );
      this.packetQueue.enqueue(
        new NetworkQueueEntry(
          networkBuffer,
          allClients,
          PACKET_PRIORITY.CRITICAL
        )
      );
    } catch (error) {
      console.log(`server error:\n${error.stack}`);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
    }
  }
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}
