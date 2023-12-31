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
import NetworkConnectionSampler from "../connection_sampling/NetworkConnectionSampler.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";
import NetworkQueueEntry from "./NetworkQueueEntry.js";
import InstanceHandler from "../instances/InstanceHandler.js";
import WorldStateHandler from "../world_state/WorldStateHandler.js";
import NetworkJoinGameRequest from "./NetworkJoinGameRequest.js";
// TODO: Check these data structs (snake cased classes)

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";
// TODO: Add UUID for server broadcasting

export default class NetworkHandler {
  constructor(socket) {
    this.socket = socket;
    this.isServerRunning = true;
    this.uptime = 0;

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
    this.clientHandler = new ClientHandler();
    this.instanceHandler = new InstanceHandler(this);
    this.networkPacketHandler = new NetworkPacketHandler(
      this,
      this.networkPacketBuilder,
      this.clientHandler,
      this.instanceHandler
    );
    this.networkPacketTracker = new NetworkPacketTracker(
      this,
      this.clientHandler
    );
    this.networkConnectionSampler = new NetworkConnectionSampler(
      this,
      this.clientHandler
    );
    this.worldStateHandler = new WorldStateHandler(this, this.instanceHandler);

    this.lastUpdate = process.hrtime.bigint();
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
    if (!this.isServerRunning) return;
    try {
      const now = process.hrtime.bigint();
      const tickTime = Number(now - this.lastUpdate) / 1000000;
      this.lastUpdate = now;

      this.uptime += tickTime;

      // Update connection sampler
      this.networkConnectionSampler.update(tickTime);

      // Update packet tracker
      this.networkPacketTracker.update(tickTime);

      // Broadcast should add a packet for each client's packet queue
      const networkQueueEntry = this.packetQueue.dequeue();
      if (networkQueueEntry != undefined) {
        const networkPacket = networkQueueEntry.networkPacket;
        if (networkPacket != undefined) {
          const messageType = networkPacket.header.messageType;
          const deliveryPolicy = networkPacket.deliveryPolicy;
          if (deliveryPolicy != undefined) {
            networkQueueEntry.clients.forEach((client) => {
              if (client !== undefined) {
                if (
                  !deliveryPolicy.patchSequenceNumber &&
                  !deliveryPolicy.patchAckRange &&
                  !deliveryPolicy.toInFlightTrack
                ) {
                  // Send network packet without delivery policy
                  this.sendPacketOverUDP(networkPacket, client);
                } else {
                  const inFlightPacketTrack =
                    this.networkPacketTracker.getInFlightPacketTrack(
                      client.uuid
                    );
                  if (inFlightPacketTrack !== undefined) {
                    // Patch sequence number
                    if (deliveryPolicy.patchSequenceNumber) {
                      if (
                        !inFlightPacketTrack.patchSequenceNumber(networkPacket)
                      ) {
                        console.log(
                          "Failed to patch sequence number to network packet"
                        );
                        return;
                      }
                    }
                    // Patch ACK range
                    if (deliveryPolicy.patchAckRange) {
                      if (!inFlightPacketTrack.patchAckRange(networkPacket)) {
                        console.log(
                          "Failed to patch Ack range to network packet"
                        );
                        return;
                      }
                    }
                    // Add to in-flight tracking
                    if (deliveryPolicy.toInFlightTrack) {
                      if (
                        !inFlightPacketTrack.addNetworkPacket(networkPacket)
                      ) {
                        console.log(
                          "Failed to add a network packet to in-flight track"
                        );
                        return;
                      }
                    }

                    // Check start pinging
                    if (messageType === MESSAGE_TYPE.PONG) {
                      if (
                        this.networkConnectionSampler.startPinging(client.uuid)
                      ) {
                        const clientConnectionSample =
                          this.networkConnectionSampler.getClientConnectionSample(
                            client.uuid
                          );
                        if (clientConnectionSample !== undefined) {
                          const pingSample = clientConnectionSample.pingSample;
                          networkPacket.payload = pingSample;
                        }
                      }
                    }

                    // Send patched network packet
                    const sentPacketSize = this.sendPacketOverUDP(
                      networkPacket,
                      client
                    );
                    // TODO: Check MTU threshold
                    // Update client data sent rate
                    const clientConnectionSample =
                      this.networkConnectionSampler.getClientConnectionSample(
                        client.uuid
                      );
                    if (clientConnectionSample !== undefined) {
                      clientConnectionSample.dataSentRate += sentPacketSize;
                    }
                  }
                }
              }
            });
          }
        }
      }

      // Pause update calls on empty server
      if (this.clientHandler.getClientCount() > 0) {
        // Update world state
        this.worldStateHandler.update(tickTime);
        // Update instances
        this.instanceHandler.update(tickTime);
      }

      return setTimeout(() => {
        this.tick();
      }, 0);
    } catch (error) {
      console.log(error);
      this.onError(error);
      setTimeout(() => {
        this.onServerClose();
      }, 2000);
      return false;
    }
  }

  sendPacketOverUDP(networkPacket, client) {
    let sentPacketSize = 0;
    const networkBuffer =
      this.networkPacketBuilder.createNetworkBuffer(networkPacket);
    if (networkBuffer !== undefined) {
      this.socket.send(networkBuffer, client.port, client.address, (err) => {
        if (err ?? undefined !== undefined) {
          console.log(err);
        }
      });
      // TODO: Check MTU threshold
      sentPacketSize = networkBuffer.length * 0.001; // Convert to kb
    }
    console.log(
      `Network packet (${networkPacket.header.messageType}) ${sentPacketSize}kb sent`
    );
    return sentPacketSize;
  }

  handleMessage(msg, rinfo) {
    try {
      let isMessageHandled = false;
      const networkPacket = this.networkPacketParser.parsePacket(msg, rinfo);
      if (networkPacket !== undefined) {
        const clientId = networkPacket.header.clientId;
        const messageType = networkPacket.header.messageType;
        const sequenceNumber = networkPacket.header.sequenceNumber;
        const ackCount = networkPacket.header.ackCount;
        const ackRange = networkPacket.header.ackRange;

        switch (messageType) {
          case MESSAGE_TYPE.CONNECT_TO_HOST:
            {
              if (clientId === UNDEFINED_UUID) {
                // Generate new Uuid and save client
                const newClientId = this.clientHandler.addClient(rinfo);
                if (newClientId !== undefined) {
                  // Add network trackers
                  this.networkPacketTracker.addInFlightPacketTrack(newClientId);
                  this.networkConnectionSampler.addConnectionSample(
                    newClientId
                  );

                  // Manually add the first outgoing acknowledgment
                  const inFlightPacketTrack =
                    this.networkPacketTracker.getInFlightPacketTrack(
                      newClientId
                    );
                  inFlightPacketTrack.pendingAckRange.push(sequenceNumber);
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
                } else {
                  console.log("Failed to connect client");
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
                rinfo.address,
                rinfo.port
              );
            }
            break;
          case MESSAGE_TYPE.CLIENT_ERROR:
            {
              const errorMessage = networkPacket.payload["error"] ?? "Unknown";
              console.log(`CLIENT ERROR: ${errorMessage}. Disconnecting...`);
              isMessageHandled = this.disconnectClientWithTimeout(
                clientId,
                rinfo.address,
                rinfo.port
              );
            }
            break;
          default: {
            if (clientId !== UNDEFINED_UUID) {
              const client = this.clientHandler.getClient(clientId);
              if (client !== undefined) {
                if (
                  this.networkPacketTracker.processAckRange(
                    ackCount,
                    ackRange,
                    clientId
                  )
                ) {
                  if (
                    this.networkPacketTracker.processSequenceNumber(
                      sequenceNumber,
                      clientId,
                      messageType
                    )
                  ) {
                    switch (messageType) {
                      case MESSAGE_TYPE.ACKNOWLEDGMENT:
                        {
                          // No further actions
                          isMessageHandled = true;
                        }
                        break;
                      case MESSAGE_TYPE.PING:
                        {
                          const pingSample = networkPacket.payload;
                          if (pingSample !== undefined) {
                            if (
                              this.networkConnectionSampler.initPinging(
                                clientId,
                                pingSample
                              )
                            ) {
                              const responsePingPong =
                                this.networkConnectionSampler.getClientConnectionSample(
                                  clientId
                                );

                              const networkPacketHeader =
                                new NetworkPacketHeader(
                                  MESSAGE_TYPE.PONG,
                                  client.uuid
                                );
                              const networkPacket = new NetworkPacket(
                                networkPacketHeader,
                                responsePingPong,
                                PACKET_PRIORITY.HIGH
                              );
                              // Patch delivery policy
                              networkPacket.deliveryPolicy.toInFlightTrack = false;

                              this.packetQueue.enqueue(
                                new NetworkQueueEntry(
                                  networkPacket,
                                  [client],
                                  networkPacket.priority
                                )
                              );
                              isMessageHandled = true;
                            }
                          }
                        }
                        break;
                      case MESSAGE_TYPE.PONG:
                        {
                          const pingSample = networkPacket.payload;
                          if (pingSample !== undefined) {
                            this.networkConnectionSampler.stopPinging(
                              clientId,
                              pingSample
                            );
                            this.queueAcknowledgmentResponse(client);
                            isMessageHandled = true;
                          }
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
                  messageType,
                  "Unknown client ID, please reconnect",
                  rinfo
                );
              }
            } else {
              isMessageHandled = this.onInvalidRequest(
                messageType,
                "Invalid client ID",
                rinfo
              );
            }
          }
        }

        if (!isMessageHandled) {
          console.log(
            `Failed to handle a message with type ${networkPacket.header.messageType} from a client`
          );
          this.onInvalidRequest(
            messageType,
            "Unable to handle the request",
            rinfo
          );
        }
      } else {
        isMessageHandled = this.onInvalidRequest(
          MESSAGE_TYPE.INVALID_REQUEST,
          "Invalid packet format",
          rinfo
        );
      }
      return isMessageHandled;
    } catch (error) {
      this.onError(error);
      setTimeout(() => {
        this.onServerClose();
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
      PACKET_PRIORITY.DEFAULT
    );
    // Patch delivery policy
    networkPacket.deliveryPolicy.toInFlightTrack = false;

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

  disconnectClientWithTimeout(clientId, clientAddress, clientPort) {
    let isDisconnecting = true;
    let client = this.clientHandler.getClient(clientId);
    if (client !== undefined) {
      // Remove connection sampling
      this.networkConnectionSampler.removeClientConnectionSample(clientId);

      // Disconnect client locally after 1 seconds
      // This provides time window to send disconnect respond
      setTimeout(() => {
        // TODO: Fix this logic to reset stream when actually operating client disconnect
        this.instanceHandler.activeOperationsScoutStream = undefined;

        let instanceId;
        const client = this.clientHandler.getClient(clientId);
        if (client !== undefined) {
          instanceId = client.instanceId;
        }
        if (
          !this.clientHandler.removeClient(clientId, clientAddress, clientPort)
        ) {
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
      client = new Client(UNDEFINED_UUID, clientAddress, clientPort);
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
    // Patch delivery policy
    networkPacket.deliveryPolicy.patchSequenceNumber = false;
    networkPacket.deliveryPolicy.patchAckRange = false;
    networkPacket.deliveryPolicy.toInFlightTrack = false;

    this.packetQueue.enqueue(
      new NetworkQueueEntry(networkPacket, [client], networkPacket.priority)
    );
    return isDisconnecting;
  }

  onInvalidRequest(originalMessageType, message, rinfo) {
    let isMessageSended = true;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.INVALID_REQUEST,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      {
        message_type: originalMessageType,
        message: message,
      },
      PACKET_PRIORITY.CRITICAL
    );
    // Patch delivery policy
    networkPacket.deliveryPolicy.patchSequenceNumber = false;
    networkPacket.deliveryPolicy.patchAckRange = false;
    networkPacket.deliveryPolicy.toInFlightTrack = false;

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
      console.log(`Server error:\n${error.stack}`);
      const allClients = this.clientHandler.getAllClients();
      const networkPacketHeader = new NetworkPacketHeader(
        MESSAGE_TYPE.SERVER_ERROR,
        UNDEFINED_UUID
      );
      const networkPacket = new NetworkPacket(
        networkPacketHeader,
        {
          error: "Internal Server Error",
        },
        PACKET_PRIORITY.CRITICAL
      );
      // Patch delivery policy
      networkPacket.deliveryPolicy.patchSequenceNumber = false;
      networkPacket.deliveryPolicy.patchAckRange = false;
      networkPacket.deliveryPolicy.toInFlightTrack = false;

      this.packetQueue.enqueue(
        new NetworkQueueEntry(networkPacket, allClients, networkPacket.priority)
      );
    } catch (error) {
      console.log(`Server error:\n${error.stack}`);
      setTimeout(() => {
        this.onServerClose();
      }, 2000);
    }
  }

  onServerClose() {
    try {
      this.socket.close();
    } catch (error) {
      console.log("Failed to close the socket");
    }
    this.isServerRunning = false;
  }
}
