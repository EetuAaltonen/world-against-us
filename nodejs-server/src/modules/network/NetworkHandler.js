import PriorityQueuePkg from "@datastructures-js/priority-queue";

import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";

import Player from "../players/Player.js";
import Client from "../clients/Client.js";
import ClientHandler from "../clients/ClientHandler.js";
import NetworkPacketParser from "./NetworkPacketParser.js";
import NetworkPacketHandler from "./NetworkPacketHandler.js";
import NetworkPacketBuilder from "./NetworkPacketBuilder.js";
import NetworkPacketTracker from "./NetworkPacketTracker.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import NetworkQueueEntry from "./NetworkQueueEntry.js";
import InstanceHandler from "../instances/InstanceHandler.js";
import WorldStateHandler from "../world_state/WorldStateHandler.js";
import NetworkJoinGameRequest from "./NetworkJoinGameRequest.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default class NetworkHandler {
  constructor(socket) {
    this.socket = socket;

    this.packetQueue = new PriorityQueuePkg.PriorityQueue((a, b) => {
      if (a.priority >= b.priority) {
        return -1;
      }
      if (a.priority < b.priority) {
        // Prioritize HIGH:0 -> LOW:N
        return 1;
      }
    });

    this.networkPacketParser = new NetworkPacketParser();
    this.networkPacketBuilder = new NetworkPacketBuilder();
    this.networkPacketTracker = new NetworkPacketTracker(this);
    this.clientHandler = new ClientHandler();
    this.instanceHandler = new InstanceHandler(this);
    this.worldStateHandler = new WorldStateHandler(this, this.instanceHandler);
    this.networkPacketHandler = new NetworkPacketHandler(
      this,
      this.networkPacketBuilder,
      this.clientHandler,
      this.instanceHandler
    );
    this.lastUpdate = process.hrtime.bigint();
    this.loopTime = 0;

    this.initWorldState();
  }

  initWorldState() {
    let isWorldStateInitialized = false;
    if (this.worldStateHandler.loadSave()) {
      isWorldStateInitialized = true;
    } else {
      this.onError(new Error("Failed to initialize world state"));
    }
    return isWorldStateInitialized;
  }

  tick() {
    try {
      const now = process.hrtime.bigint();
      const tickTime = Number(now - this.lastUpdate) / 1000000;
      this.lastUpdate = now;

      // Update packet tracker
      this.networkPacketTracker.update(tickTime);

      // TODO: Separate packet send for each client to control send rate
      // Broadcast should add a packet for each client's packet queue
      const networkQueueEntry = this.packetQueue.dequeue();
      if (networkQueueEntry != undefined) {
        const networkPacket = networkQueueEntry.networkPacket;
        networkQueueEntry.clients.forEach((client) => {
          const messageType = networkPacket.header.messageType;
          switch (messageType) {
            // Allowed message types cases without an in flight packet tracking, excluding the default case
            case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
              {
                this.sendPacketOverUDP(networkPacket, client);
              }
              break;
            case MESSAGE_TYPE.INVALID_REQUEST:
              {
                this.sendPacketOverUDP(networkPacket, client);
              }
              break;
            default: {
              const inFlightPacketTrack =
                this.networkPacketTracker.getInFlightPacketTrack(client.uuid);
              if (inFlightPacketTrack !== undefined) {
                if (
                  inFlightPacketTrack.patchNetworkPacketSequenceNumber(
                    networkPacket
                  )
                ) {
                  if (
                    inFlightPacketTrack.patchAcknowledgmentId(networkPacket)
                  ) {
                    this.sendPacketOverUDP(networkPacket, client);
                  }
                }
              } else if (MESSAGE_TYPE.SERVER_ERROR) {
                // Exception on SERVER ERRORS
                this.sendPacketOverUDP(networkPacket, client);
              }
            }
          }
        });
      }

      // Update world state
      this.worldStateHandler.update(tickTime);
      // Update instances
      this.instanceHandler.update(tickTime);

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

  sendPacketOverUDP(networkPacket, client) {
    const networkBuffer =
      this.networkPacketBuilder.createNetworkBuffer(networkPacket);
    if (networkBuffer !== undefined)
      this.socket.send(networkBuffer, client.port, client.address, (err) => {
        if (err ?? undefined !== undefined) {
          console.log(err);
        }
      });
    console.log(`Network packet ${networkBuffer.length * 0.001}kb sent`);
  }

  handleMessage(msg, rinfo) {
    try {
      let isMessageHandled = false;
      const networkPacket = this.networkPacketParser.parsePacket(msg, rinfo);
      if (networkPacket !== undefined) {
        const clientId = networkPacket.header.clientId;
        const messageType = networkPacket.header.messageType;
        const sequenceNumber = networkPacket.header.sequenceNumber;
        const acknowledgmentId = networkPacket.header.acknowledgmentId;

        switch (messageType) {
          case MESSAGE_TYPE.CONNECT_TO_HOST:
            {
              if (clientId === UNDEFINED_UUID) {
                // Generate new Uuid and save client
                const newClientId = this.clientHandler.connectClient(rinfo);
                if (newClientId !== undefined) {
                  this.networkPacketTracker.addInFlightPacketTrack(newClientId);

                  // Manually add the first outgoing acknowledgment
                  const inFlightPacketTrack =
                    this.networkPacketTracker.getInFlightPacketTrack(
                      newClientId
                    );
                  inFlightPacketTrack.pendingAcknowledgments.push(
                    sequenceNumber
                  );
                  inFlightPacketTrack.expectedSequenceNumber =
                    sequenceNumber + 1;

                  const client = this.clientHandler.getClient(newClientId);
                  const networkPacketHeader = new NetworkPacketHeader(
                    MESSAGE_TYPE.CONNECT_TO_HOST,
                    newClientId
                  );
                  const networkPacket = new NetworkPacket(
                    networkPacketHeader,
                    undefined,
                    PACKET_PRIORITY.HIGH
                  );
                  this.packetQueue.enqueue(
                    new NetworkQueueEntry(
                      networkPacket,
                      [client],
                      networkPacket.priority
                    )
                  );
                  isMessageHandled = true;
                }
              } else {
                console.log(
                  `Client with UUID ${clientId} requested to join game`
                );
              }
            }
            break;
          case MESSAGE_TYPE.DISCONNECT_FROM_HOST:
            {
              isMessageHandled = this.disconnectClientWithTimeout(
                clientId,
                rinfo
              );
            }
            break;
          case MESSAGE_TYPE.CLIENT_ERROR:
            {
              const errorMessage = networkPacket.payload["error"] ?? "Unknown";
              console.log(`CLIENT ERROR: ${errorMessage}. Disconnecting...`);
              isMessageHandled = this.disconnectClientWithTimeout(
                clientId,
                rinfo
              );
            }
            break;
          default: {
            if (clientId !== UNDEFINED_UUID) {
              const client = this.clientHandler.getClient(clientId);
              if (client !== undefined) {
                if (
                  this.networkPacketTracker.processSequenceNumber(
                    sequenceNumber,
                    clientId,
                    messageType
                  )
                ) {
                  if (
                    this.networkPacketTracker.processAcknowledgment(
                      acknowledgmentId,
                      clientId
                    )
                  ) {
                    switch (messageType) {
                      case MESSAGE_TYPE.ACKNOWLEDGMENT:
                        {
                          // No further actions
                          isMessageHandled = true;
                        }
                        break;
                      case MESSAGE_TYPE.REQUEST_JOIN_GAME:
                        {
                          const player = new Player(`Player_${clientId}`);
                          const instanceId =
                            this.instanceHandler.addPlayerToDefaultInstance(
                              clientId,
                              player
                            );
                          const instance =
                            this.instanceHandler.getInstance(instanceId);
                          if (instance !== undefined) {
                            // Set new instance
                            client.setInstanceId(instanceId);
                            const networkJoinGameRequest =
                              new NetworkJoinGameRequest(
                                instanceId,
                                instance.roomIndex,
                                instance.ownerClient
                              );
                            const networkPacketHeader = new NetworkPacketHeader(
                              MESSAGE_TYPE.REQUEST_JOIN_GAME,
                              clientId
                            );
                            const networkPacket = new NetworkPacket(
                              networkPacketHeader,
                              networkJoinGameRequest,
                              PACKET_PRIORITY.HIGH
                            );
                            this.packetQueue.enqueue(
                              new NetworkQueueEntry(
                                networkPacket,
                                [client],
                                networkPacket.priority
                              )
                            );
                            isMessageHandled = true;
                          } else {
                            client.resetInstanceId();
                          }
                        }
                        break;
                      default: {
                        isMessageHandled =
                          this.networkPacketHandler.handlePacket(
                            client,
                            rinfo,
                            networkPacket
                          );
                      }
                    }
                  }
                }
              } else {
                isMessageHandled = this.onInvalidRequest(
                  "Unknown client ID",
                  rinfo
                );
              }
            } else {
              isMessageHandled = this.onInvalidRequest(
                "Invalid client ID",
                rinfo
              );
            }
          }
        }
      } else {
        isMessageHandled = this.onInvalidRequest(
          "Invalid packet format",
          rinfo
        );
      }
      return isMessageHandled;
    } catch (error) {
      this.onError(error);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
    }
  }

  queueAcknowledgmentResponse(client) {
    let isResponseQueued = true;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.ACKNOWLEDGMENT,
      client.uuid
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      undefined,
      PACKET_PRIORITY.HIGH
    );
    this.packetQueue.enqueue(
      new NetworkQueueEntry(networkPacket, [client], networkPacket.priority)
    );
    return isResponseQueued;
  }

  broadcastWeather(weatherCondition) {
    let isWeatherBroadcasted = false;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.SYNC_WORLD_STATE_WEATHER,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      weatherCondition,
      PACKET_PRIORITY.HIGH
    );
    const clientsInGame = this.clientHandler
      .getAllClients()
      .filter((client) => client.instanceId !== undefined);
    isWeatherBroadcasted = this.broadcast(networkPacket, clientsInGame);
    return isWeatherBroadcasted;
  }

  broadcastPatrolState(instanceId, patrolState) {
    let isStateBroadcasted = false;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.PATROL_STATE,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      patrolState,
      PACKET_PRIORITY.HIGH
    );
    const clientsInInstance = this.clientHandler
      .getAllClients()
      .filter((client) => client.instanceId === instanceId);
    isStateBroadcasted = this.broadcast(networkPacket, clientsInInstance);
    return isStateBroadcasted;
  }

  broadcast(networkPacket, clients) {
    let isBroadcasted = false;
    if (networkPacket !== undefined) {
      if (clients.length > 0) {
        this.packetQueue.enqueue(
          new NetworkQueueEntry(networkPacket, clients, networkPacket.priority)
        );
      }
      isBroadcasted = true;
    }
    return isBroadcasted;
  }

  disconnectClientWithTimeout(clientId, rinfo) {
    let isDisconnecting = true;
    let client = this.clientHandler.getClient(clientId);
    if (client !== undefined) {
      // Disconnect client locally after 1 seconds
      // This provides time window to respond to disconnect
      setTimeout(() => {
        let instanceId;
        const client = this.clientHandler.getClient(clientId);
        if (client !== undefined) {
          instanceId = client.instanceId;
        }
        if (this.clientHandler.disconnectClient(clientId, rinfo)) {
          this.networkPacketTracker.removeInFlightPacketTrack(clientId);
          if (client.instanceId !== undefined) {
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
          }
        } else {
          // TODO: Proper error handling
          console.log(`Failed to disconnect a client with ID: ${clientId}`);
        }
      }, 1000);
    } else {
      client = new Client(UNDEFINED_UUID, rinfo.address, rinfo.port);
    }
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.DISCONNECT_FROM_HOST,
      clientId
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      undefined,
      PACKET_PRIORITY.CRITICAL
    );
    this.packetQueue.enqueue(
      new NetworkQueueEntry(networkPacket, [client], networkPacket.priority)
    );
    return isDisconnecting;
  }

  onInvalidRequest(message, rinfo) {
    let isMessageSended = true;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.INVALID_REQUEST,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      {
        message: message,
      },
      PACKET_PRIORITY.CRITICAL
    );
    this.packetQueue.enqueue(
      new NetworkQueueEntry(
        networkPacket,
        [new Client(UNDEFINED_UUID, rinfo.address, rinfo.port)],
        networkPacket.priority
      )
    );
    return isMessageSended;
  }

  onError(error) {
    try {
      console.log(`server error:\n${error.stack}`);
      const allClients = this.clientHandler.getAllClients();
      const networkPacketHeader = new NetworkPacketHeader(
        MESSAGE_TYPE.SERVER_ERROR,
        UNDEFINED_UUID
      );
      const networkPacket = new NetworkPacket(
        networkPacketHeader,
        {
          error: "Internal Server Error.",
        },
        PACKET_PRIORITY.CRITICAL
      );
      this.packetQueue.enqueue(
        new NetworkQueueEntry(networkPacket, allClients, networkPacket.priority)
      );
    } catch (error) {
      console.log(`server error:\n${error.stack}`);
      setTimeout(() => {
        this.socket.close();
      }, 2000);
    }
  }
}
