import PriorityQueuePkg from "@datastructures-js/priority-queue";

import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";

import Player from "../players/Player.js";
import Client from "../clients/Client.js";
import ClientHandler from "../clients/ClientHandler.js";
import NetworkPacketParser from "./NetworkPacketParser.js";
import NetworkPacketHandler from "./NetworkPacketHandler.js";
import NetworkPacketBuilder from "./NetworkPacketBuilder.js";
import NetworkQueueEntry from "./NetworkQueueEntry.js";
import InstanceHandler from "../instances/InstanceHandler.js";
import WorldStateHandler from "../world_state/WorldStateHandler.js";
import NetworkJoinGameRequest from "./NetworkJoinGameRequest.js";

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
    this.worldStateHandler = new WorldStateHandler(this);

    this.networkPacketHandler = new NetworkPacketHandler(
      this,
      this.networkPacketBuilder,
      this.clientHandler,
      this.instanceHandler
    );

    this.lastUpdate = process.hrtime.bigint();
    this.loopTime = 0;
  }

  tick() {
    try {
      const now = process.hrtime.bigint();
      const tickTime = Number(now - this.lastUpdate) / 1000000;
      this.lastUpdate = now;

      // TODO: Separate packet send for each client to control send rate
      // Broadcast should add a packet for each client's packet queue
      const queuePacket = this.packetQueue.dequeue();
      if (queuePacket != undefined) {
        queuePacket.clients.forEach((client) => {
          this.socket.send(queuePacket.packet, client.port, client.address);
          console.log(
            `Network packet ${queuePacket.packet.length * 0.001}kb sent`
          );
        });
      }

      // Update world state
      this.worldStateHandler.update(tickTime);

      return setTimeout(() => {
        this.tick();
      }, 0);
    } catch (error) {
      console.log(error);
      this.onError(error);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
      return false;
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

              if (networkBuffer !== undefined) {
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
              const instance = this.instanceHandler.getInstance(instanceId);
              if (instance !== undefined) {
                // Set new instance
                client.setInstanceId(instanceId);

                const networkJoinGameRequest = new NetworkJoinGameRequest(
                  instanceId,
                  instance.roomIndex,
                  instance.ownerClient
                );
                const networkBuffer = this.networkPacketBuilder.createPacket(
                  MESSAGE_TYPE.REQUEST_JOIN_GAME,
                  clientId,
                  acknowledgmentId,
                  networkJoinGameRequest
                );

                if (networkBuffer !== undefined) {
                  this.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkBuffer,
                      [client],
                      PACKET_PRIORITY.HIGH
                    )
                  );
                  isMessageHandled = true;
                }
              } else {
                client.resetInstanceId();
              }
            }
          }
          break;
        case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
          {
            let instanceId;
            const client = this.clientHandler.getClient(clientId);
            if (client !== undefined) {
              instanceId = client.instanceId;
            }
            if (this.clientHandler.disconnectClient(clientId, rinfo)) {
              isMessageHandled = true;
              if (
                !this.instanceHandler.removePlayerFromInstance(
                  clientId,
                  instanceId
                )
              ) {
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
          if (clientId !== UNDEFINED_UUID) {
            const client = this.clientHandler.getClient(clientId);
            if (client !== undefined) {
              isMessageHandled = this.networkPacketHandler.handlePacket(
                client,
                networkPacket
              );
            } else {
              const networkBuffer = this.networkPacketBuilder.createPacket(
                MESSAGE_TYPE.SERVER_ERROR,
                UNDEFINED_UUID,
                -1,
                {
                  error: "Unknown client.",
                }
              );
              if (networkBuffer !== undefined) {
                this.packetQueue.enqueue(
                  new NetworkQueueEntry(
                    networkBuffer,
                    [new Client(UNDEFINED_UUID, rinfo.address, rinfo.port)],
                    PACKET_PRIORITY.CRITICAL
                  )
                );
                isMessageHandled = true;
              }
            }
          }
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

  broadcastWeather(weatherCondition) {
    let isWeatherBroadcasted = false;
    const networkBuffer = this.networkPacketBuilder.createPacket(
      MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER,
      UNDEFINED_UUID,
      -1,
      weatherCondition
    );
    const clientsInGame = this.clientHandler
      .getAllClients()
      .filter((client) => client.instanceId !== undefined);
    isWeatherBroadcasted = this.broadcast(networkBuffer, clientsInGame);
    return isWeatherBroadcasted;
  }

  broadcast(networkBuffer, clients) {
    let isBroadcasted = false;
    if (networkBuffer !== undefined) {
      if (clients.length > 0) {
        this.packetQueue.enqueue(
          new NetworkQueueEntry(networkBuffer, clients, PACKET_PRIORITY.HIGH)
        );
      }
      isBroadcasted = true;
    }
    return isBroadcasted;
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
      if (networkBuffer !== undefined) {
        this.packetQueue.enqueue(
          new NetworkQueueEntry(
            networkBuffer,
            allClients,
            PACKET_PRIORITY.CRITICAL
          )
        );
      }
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
