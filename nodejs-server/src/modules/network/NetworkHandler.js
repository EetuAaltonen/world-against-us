import MESSAGE_TYPE from "./MessageType.js";
import PACKET_PRIORITY from "./PacketPriority.js";
import INVALID_REQUEST_ACTION from "../invalid_request/InvalidRequestAction.js";

import ConsoleHandler from "../console/ConsoleHandler.js";
import InvalidRequestInfo from "../invalid_request/InvalidRequestInfo.js";
import Player from "../players/Player.js";
import Client from "../clients/Client.js";
import RemotePlayerInfo from "../players/RemotePlayerInfo.js";
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
const SERVER_BROADCAST_UUID = "serveruu-uuuu-uuuu-uuuu-uuubroadcast";

export default class NetworkHandler {
  constructor(socket) {
    this.socket = socket;
    this.isServerRunning = true;
    this.uptime = 0;

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

      const allClients = this.clientHandler.getAllClients();
      allClients.forEach((client) => {
        if (client !== undefined) {
          let networkPacket = client.getPacketToSend(tickTime);
          if (networkPacket !== undefined) {
            if (
              !this.prepareAndSendNetworkPacket(
                networkPacket,
                client.port,
                client.address,
                client
              )
            ) {
              ConsoleHandler.Log(
                `Failed to send network packet to client with ID ${client.uuid}`
              );
            }
          }
        }
      });

      // Pause update calls on empty server
      if (this.clientHandler.getClientCount() > 0) {
        // Update world state
        this.worldStateHandler.update(tickTime);
        // Update instances
        this.instanceHandler.update(tickTime);
      }

      // Update auto save timer
      this.worldStateHandler.updateAutoSave(tickTime);

      return setTimeout(() => {
        this.tick();
      }, 0);
    } catch (error) {
      ConsoleHandler.Log(error);
      this.onError(error);
      setTimeout(() => {
        this.onServerClose();
      }, 2000);
      return false;
    }
  }

  queueNetworkPacket(networkQueueEntry) {
    const networkPacket = networkQueueEntry.networkPacket;
    networkQueueEntry.clients.forEach((client) => {
      // Make clone from original network packet without header ref
      const networkPacketClone =
        networkQueueEntry.clients.length > 1
          ? networkPacket.clone()
          : networkPacket;
      if (client !== undefined) {
        if (networkPacketClone.priority <= PACKET_PRIORITY.HIGH) {
          client.priorityPacketQueue.push(networkPacketClone);
        } else {
          client.packetQueue.push(networkPacketClone);
        }
      }
    });
  }

  prepareAndSendNetworkPacket(
    networkPacket,
    port,
    address,
    client = undefined
  ) {
    let isNetworkPacketSent = false;
    if (client !== undefined) {
      const inFlightPacketTrack =
        this.networkPacketTracker.getInFlightPacketTrack(client.uuid);
      if (inFlightPacketTrack !== undefined) {
        // Patch ACK range
        // Patch before sequence number to avoid conflicts with dropped unnecessary ACK packets
        if (!inFlightPacketTrack.patchNetworkPacketAckRange(networkPacket)) {
          ConsoleHandler.Log("Failed to patch Ack range to network packet");
          return;
        }
        // Patch sequence number
        if (
          !inFlightPacketTrack.patchNetworkPacketSequenceNumber(networkPacket)
        ) {
          ConsoleHandler.Log(
            "Failed to patch sequence number to network packet"
          );
          return;
        }
      }
    }

    // Create network buffer
    const networkBuffer =
      this.networkPacketBuilder.createNetworkBuffer(networkPacket);
    if (networkBuffer !== undefined) {
      // TODO: Check MTU threshold
      // Send patched network packet
      if (this.sendNetworkPacketUDP(networkBuffer, port, address)) {
        const sentNetworkPacketBytes = networkBuffer.length;
        this.onNetworkPacketSend(networkPacket, client, sentNetworkPacketBytes);
        isNetworkPacketSent = true;
      } else {
        ConsoleHandler.Log(
          `Failed to send network packet with message type ${networkPacket.header.messageType}`
        );
      }
    } else {
      ConsoleHandler.Log(
        `Failed to create network packet with message type ${networkPacket.header.messageType}`
      );
    }
    return isNetworkPacketSent;
  }

  sendNetworkPacketUDP(networkBuffer, port, address) {
    let isNetworkPacketSent = false;
    if (networkBuffer !== undefined) {
      this.socket.send(networkBuffer, port, address, (err) => {
        if (err ?? undefined !== undefined) {
          ConsoleHandler.Log(err);
        }
      });
      isNetworkPacketSent = true;
    }
    return isNetworkPacketSent;
  }

  onNetworkPacketSend(
    networkPacket,
    client = undefined,
    sentNetworkPacketBytes = undefined
  ) {
    const deliveryPolicy = networkPacket.deliveryPolicy;
    if (client !== undefined) {
      const inFlightPacketTrack =
        this.networkPacketTracker.getInFlightPacketTrack(client.uuid);
      if (inFlightPacketTrack !== undefined) {
        // Add network packet to in-flight tracking
        if (deliveryPolicy.toInFlightTrack) {
          if (!inFlightPacketTrack.addNetworkPacket(networkPacket)) {
            ConsoleHandler.Log(
              "Failed to add a network packet to in-flight track"
            );
            return;
          }
        }
        // Clear pending ACK range
        if (deliveryPolicy.patchAckRange) {
          inFlightPacketTrack.pendingAckRange = [];
        }
      }
      // Update client data sent rate
      if (sentNetworkPacketBytes !== undefined) {
        this.networkConnectionSampler.updateClientSendRate(
          client.uuid,
          sentNetworkPacketBytes
        );
      }
    }
  }

  handleMessage(msg, rinfo) {
    try {
      let isMessageHandled = false;
      const networkPacket = this.networkPacketParser.parsePacket(msg);
      if (networkPacket !== undefined) {
        const messageType = networkPacket.header.messageType;
        // Handle pinging
        if (messageType == MESSAGE_TYPE.PING) {
          const client = this.clientHandler.getClientBySocket(
            rinfo.port,
            rinfo.address
          );
          if (client !== undefined) {
            const clientTime = networkPacket.payload;
            if (
              this.networkConnectionSampler.handlePingMessage(
                clientTime,
                client
              )
            ) {
              // Respond with ping packet
              isMessageHandled = this.prepareAndSendNetworkPacket(
                networkPacket,
                rinfo.port,
                rinfo.address,
                client
              );
            } else {
              isMessageHandled = this.onInvalidRequest(
                new InvalidRequestInfo(
                  INVALID_REQUEST_ACTION.DISCONNECT,
                  messageType,
                  "Failed to ping the client, please reconnect"
                ),
                rinfo
              );
            }
          } else {
            isMessageHandled = this.onUnknownClientID(messageType, rinfo);
          }
        } else {
          const clientId = networkPacket.header.clientId;
          const sequenceNumber = networkPacket.header.sequenceNumber;
          const ackCount = networkPacket.header.ackCount;
          const ackRange = networkPacket.header.ackRange;
          switch (messageType) {
            case MESSAGE_TYPE.CONNECT_TO_HOST:
              {
                // Check if client is already connected
                if (
                  this.clientHandler.getClientBySocket(
                    rinfo.port,
                    rinfo.address
                  ) === undefined
                ) {
                  const playerTag = networkPacket.payload;
                  if (playerTag !== undefined) {
                    // Check minimum player tag length
                    if (playerTag.length >= 3) {
                      if (clientId === UNDEFINED_UUID) {
                        // Generate new Uuid and save client
                        const newClientId = this.clientHandler.addClient(
                          rinfo,
                          playerTag
                        );
                        ConsoleHandler.Log(
                          `Player '${playerTag}' connected to the server`
                        );
                        if (newClientId !== undefined) {
                          // Add network trackers
                          this.networkPacketTracker.addInFlightPacketTrack(
                            newClientId
                          );
                          this.networkConnectionSampler.addConnectionSample(
                            newClientId
                          );

                          // Manually add the first outgoing acknowledgment
                          const inFlightPacketTrack =
                            this.networkPacketTracker.getInFlightPacketTrack(
                              newClientId
                            );
                          inFlightPacketTrack.pendingAckRange.push(
                            sequenceNumber
                          );
                          inFlightPacketTrack.expectedSequenceNumber =
                            sequenceNumber + 1;

                          // Response with connect to host message for client proceed
                          const client =
                            this.clientHandler.getClient(newClientId);
                          const networkPacketHeader = new NetworkPacketHeader(
                            MESSAGE_TYPE.CONNECT_TO_HOST,
                            newClientId
                          );
                          const networkPacket = new NetworkPacket(
                            networkPacketHeader,
                            undefined,
                            PACKET_PRIORITY.HIGH
                          );
                          this.queueNetworkPacket(
                            new NetworkQueueEntry(networkPacket, [client])
                          );

                          // Broadcast about connected client
                          const remotePlayerInfo = new RemotePlayerInfo(
                            newClientId,
                            playerTag
                          );
                          const clientsToBroadcast =
                            this.clientHandler.getClientsToBroadcastGlobal(
                              newClientId
                            );
                          const broadcastNetworkPacketHeader =
                            new NetworkPacketHeader(
                              MESSAGE_TYPE.REMOTE_CONNECTED_TO_HOST,
                              newClientId
                            );
                          const broadcastNetworkPacket = new NetworkPacket(
                            broadcastNetworkPacketHeader,
                            remotePlayerInfo,
                            PACKET_PRIORITY.DEFAULT
                          );
                          this.broadcast(
                            broadcastNetworkPacket,
                            clientsToBroadcast
                          );

                          isMessageHandled = true;
                        } else {
                          ConsoleHandler.Log("Failed to connect client");
                        }
                      } else {
                        ConsoleHandler.Log(
                          `Client with UUID ${clientId} requested to join game`
                        );
                      }
                    }
                  }
                } else {
                  isMessageHandled = this.onInvalidRequest(
                    new InvalidRequestInfo(
                      INVALID_REQUEST_ACTION.DISCONNECT,
                      messageType,
                      "Failed to connect"
                    ),
                    rinfo
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
                const errorMessage =
                  networkPacket.payload["error"] ?? "Unknown";
                ConsoleHandler.Log(
                  `CLIENT ERROR: ${errorMessage}. Disconnecting...`
                );
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
                        case MESSAGE_TYPE.REQUEST_JOIN_GAME:
                          {
                            const player = new Player(
                              clientId,
                              client.playerTag
                            );
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

                              // Response with join game request
                              const networkPacketHeader =
                                new NetworkPacketHeader(
                                  MESSAGE_TYPE.REQUEST_JOIN_GAME,
                                  clientId
                                );
                              const networkPacket = new NetworkPacket(
                                networkPacketHeader,
                                networkJoinGameRequest,
                                PACKET_PRIORITY.HIGH
                              );
                              this.queueNetworkPacket(
                                new NetworkQueueEntry(networkPacket, [client])
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
                  isMessageHandled = this.onUnknownClientID(messageType, rinfo);
                }
              } else {
                isMessageHandled = this.onUnknownClientID(messageType, rinfo);
              }
            }
          }
        }

        if (!isMessageHandled) {
          ConsoleHandler.Log(
            `Failed to handle a message with type ${networkPacket.header.messageType} from a client`
          );
          this.onInvalidRequest(
            new InvalidRequestInfo(
              INVALID_REQUEST_ACTION.CANCEL_ACTION,
              messageType,
              "Unable to handle the request"
            ),
            rinfo
          );
        }
      } else {
        isMessageHandled = this.onInvalidRequest(
          new InvalidRequestInfo(
            INVALID_REQUEST_ACTION.DISCONNECT,
            MESSAGE_TYPE.INVALID_REQUEST,
            "Invalid packet format"
          ),
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
    let isResponseQueued = false;
    const inFlightPacketTrack =
      this.networkPacketTracker.getInFlightPacketTrack(client.uuid);
    if (inFlightPacketTrack !== undefined) {
      // Check for pending ACKs
      if (inFlightPacketTrack.pendingAckRange.length > 0) {
        const headNetworkPacket =
          client.priorityPacketQueue.length > 0
            ? client.priorityPacketQueue[0]
            : client.packetQueue[0];
        if (headNetworkPacket !== undefined) {
          // Do not queue ACKs if head has ACK range patch set
          if (headNetworkPacket.deliveryPolicy.patchAckRange) return true;
        }

        const networkPacketHeader = new NetworkPacketHeader(
          MESSAGE_TYPE.ACKNOWLEDGMENT,
          client.uuid
        );
        const networkPacket = new NetworkPacket(
          networkPacketHeader,
          undefined,
          PACKET_PRIORITY.DEFAULT
        );
        this.queueNetworkPacket(new NetworkQueueEntry(networkPacket, [client]));
        isResponseQueued = true;
      } else {
        // Do not queue unnecessary ACKs
        isResponseQueued = true;
      }
    }
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
    const clientsInGame = this.clientHandler.getClientsToBroadcastInGame();
    isWeatherBroadcasted = this.broadcast(networkPacket, clientsInGame);
    return isWeatherBroadcasted;
  }

  broadcastPatrolState(
    instanceId,
    patrolState,
    excludeClientId = UNDEFINED_UUID
  ) {
    let isStateBroadcasted = false;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.SYNC_PATROL_STATE,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      patrolState,
      PACKET_PRIORITY.HIGH
    );
    const clientsInInstance = this.clientHandler.getClientsToBroadcastInstance(
      instanceId,
      excludeClientId
    );
    isStateBroadcasted = this.broadcast(networkPacket, clientsInInstance);
    return isStateBroadcasted;
  }

  broadcastPatrolActionRob(patrolActionRob) {
    let isStateBroadcasted = false;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.PATROL_ACTION_ROB,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      patrolActionRob,
      PACKET_PRIORITY.HIGH
    );
    const clientsInInstance = this.clientHandler.getClientsToBroadcastInGame();
    isStateBroadcasted = this.broadcast(networkPacket, clientsInInstance);
    return isStateBroadcasted;
  }

  broadcast(networkPacket, clients) {
    let isBroadcasted = false;
    if (networkPacket !== undefined) {
      // Patch server broadcast UUID
      networkPacket.header.clientId = SERVER_BROADCAST_UUID;

      if (clients.length > 0) {
        this.queueNetworkPacket(new NetworkQueueEntry(networkPacket, clients));
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

      // Clear network packet queue before definitive deletion
      client.clearPacketQueue();

      // Clear in-flight packet track before definitive deletion
      this.networkPacketTracker.clearInFlightPacketTrack(clientId);

      // Broadcast about disconnected client
      const remotePlayerInfo = new RemotePlayerInfo(clientId, client.playerTag);
      const clientsToBroadcast =
        this.clientHandler.getClientsToBroadcastGlobal(clientId);
      const broadcastNetworkPacketHeader = new NetworkPacketHeader(
        MESSAGE_TYPE.REMOTE_DISCONNECT_FROM_HOST,
        client.uuid
      );
      const broadcastNetworkPacket = new NetworkPacket(
        broadcastNetworkPacketHeader,
        remotePlayerInfo,
        PACKET_PRIORITY.DEFAULT
      );
      this.broadcast(broadcastNetworkPacket, clientsToBroadcast);

      // Disconnect client locally after 1 seconds
      // This provides time window to send disconnect respond
      setTimeout(() => {
        // Call on client disconnect to clean-up and release ongoing actions
        const client = this.clientHandler.getClient(clientId);
        if (client !== undefined) {
          this.onClientDisconnect(client);
        }

        if (
          !this.clientHandler.removeClient(clientId, clientAddress, clientPort)
        ) {
          // TODO: Proper error handling
          ConsoleHandler.Log(
            `Failed to disconnect a client with ID: ${clientId}`
          );
        }

        // Autosave on last client disconnect
        if (this.clientHandler.getClientCount() <= 0) {
          this.worldStateHandler.autosave();
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

    this.queueNetworkPacket(new NetworkQueueEntry(networkPacket, [client]));
    return isDisconnecting;
  }

  onClientDisconnect(client) {
    const clientId = client.uuid;
    // Remove in-flight packet track
    this.networkPacketTracker.removeInFlightPacketTrack(clientId);

    // End operations scout stream
    if (this.instanceHandler.activeOperationsScoutStream !== undefined) {
      if (
        this.instanceHandler.activeOperationsScoutStream.operatingClient ===
        clientId
      ) {
        this.instanceHandler.activeOperationsScoutStream = undefined;
      }
    }

    // Remove player from instance
    if (client.instanceId !== undefined) {
      if (
        !this.instanceHandler.removePlayerFromInstance(
          clientId,
          client.instanceId
        )
      ) {
        // TODO: Proper error handling
        ConsoleHandler.Log(
          `Failed to remove a client with ID: ${clientId} from any instance`
        );
      }
    }

    ConsoleHandler.Log(
      `Player '${client.playerTag}' disconnected from the server`
    );
  }

  onUnknownClientID(messageType, rinfo) {
    return this.onInvalidRequest(
      new InvalidRequestInfo(
        INVALID_REQUEST_ACTION.DISCONNECT,
        messageType,
        "Unknown client ID, please reconnect"
      ),
      rinfo
    );
  }

  onInvalidRequest(invalidRequestInfo, rinfo) {
    let isResponseSent = true;
    const networkPacketHeader = new NetworkPacketHeader(
      MESSAGE_TYPE.INVALID_REQUEST,
      UNDEFINED_UUID
    );
    const networkPacket = new NetworkPacket(
      networkPacketHeader,
      invalidRequestInfo,
      PACKET_PRIORITY.CRITICAL
    );

    // Respond with invalid request details
    isResponseSent = this.prepareAndSendNetworkPacket(
      networkPacket,
      rinfo.port,
      rinfo.address
    );
    return isResponseSent;
  }

  onError(error) {
    try {
      ConsoleHandler.Log(`Server error:\n${error.stack}`);
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

      this.queueNetworkPacket(new NetworkQueueEntry(networkPacket, allClients));
    } catch (error) {
      ConsoleHandler.Log(`Server error:\n${error.stack}`);
      setTimeout(() => {
        this.onServerClose();
      }, 2000);
    }
  }

  onServerClose() {
    try {
      this.socket.close();
    } catch (error) {
      ConsoleHandler.Log("Failed to close the socket");
    }
    this.isServerRunning = false;
  }
}
