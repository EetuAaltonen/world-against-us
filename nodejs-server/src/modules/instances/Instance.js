import MESSAGE_TYPE from "../network/MessageType.js";
import PACKET_PRIORITY from "../network/PacketPriority.js";
import ROOM_INDEX from "./RoomIndex.js";
import AI_STATE from "../patrols/AIState.js";

import ConsoleHandler from "../console/ConsoleHandler.js";
import NetworkPacketHeader from "../network_packets/NetworkPacketHeader.js";
import NetworkPacket from "../network_packets/NetworkPacket.js";

import ContainerHandler from "../containers/ContainerHandler.js";
import Patrol from "../patrols/Patrol.js";
import PatrolState from "../patrols/PatrolState.js";
import InstanceSnapshot from "./InstanceSnapshot.js";

import GetRandomInt from "../math/GetRandomInt.js";
import FormatHashMapToJSONStructArray from "../formatting/FormatHashMapToJSONStructArray.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

const PATROL_ROUTE_TIME_TOWN = 255000; // == ~4min 15sec
const PATROL_ROUTE_TIME_FOREST = 83000; // == ~1min 23sec
const MAX_PATROL_ID = 100;
const MIN_PATROL_COUNT = 1;
const MAX_PATROL_COUNT = 2;

const SNAPSHOT_SEND_RATE = 1000 / 20; // == 100ms

export default class Instance {
  constructor(instanceId, roomIndex, networkHandler) {
    this.instanceId = instanceId;
    this.roomIndex = roomIndex;
    this.networkHandler = networkHandler;
    this.parentInstanceId = undefined;
    this.ownerClient = undefined;
    this.localPlayers = {};
    this.localPatrols = {};
    this.containerHandler = new ContainerHandler(this.networkHandler);

    this.availablePatrolId = 0;

    this.snapshotSendTimer = 0;
    this.isNewSnapshotRequired = true;
  }

  toJSONStruct() {
    const formatOwnerClient = this.ownerClient ?? UNDEFINED_UUID;
    const formatLocalPlayers = FormatHashMapToJSONStructArray(
      this.localPlayers
    );
    const arrivedPatrols = Object.values(this.localPatrols).filter(
      (patrolJSONObject) => patrolJSONObject.travelTime <= 0
    );
    const formatPatrols = FormatHashMapToJSONStructArray(arrivedPatrols);
    return {
      region_id: this.instanceId,
      room_index: this.roomIndex,
      owner_client: formatOwnerClient,
      local_players: formatLocalPlayers,
      arrived_patrols: formatPatrols,
    };
  }

  update(passedTickTime) {
    let isUpdated = true;
    if (this.roomIndex === ROOM_INDEX.ROOM_CAMP) {
      // TODO: Update the Camp
    } else {
      isUpdated = this.updateLocalPatrols(passedTickTime);
    }

    this.snapshotSendTimer += passedTickTime;
    if (this.snapshotSendTimer >= SNAPSHOT_SEND_RATE) {
      this.snapshotSendTimer -= SNAPSHOT_SEND_RATE;

      if (this.isNewSnapshotRequired) {
        this.isNewSnapshotRequired = false;

        // Broad cast instance snapshot within the instance
        const clientsToBroadcast =
          this.networkHandler.clientHandler.getClientsToBroadcastInstance(
            this.instanceId
          );
        const broadcastNetworkPacketHeader = new NetworkPacketHeader(
          MESSAGE_TYPE.INSTANCE_SNAPSHOT_DATA,
          undefined
        );
        const instanceSnapshot = this.fetchInstanceSnapshot();

        const broadcastNetworkPacket = new NetworkPacket(
          broadcastNetworkPacketHeader,
          instanceSnapshot,
          PACKET_PRIORITY.DEFAULT
        );
        this.networkHandler.broadcast(
          broadcastNetworkPacket,
          clientsToBroadcast
        );
      }
    }
    return isUpdated;
  }

  fetchInstanceSnapshot() {
    return new InstanceSnapshot(
      this.instanceId,
      this.getAllPlayers(),
      this.getAllLocalPatrols()
    );
  }

  addPlayer(clientId, player) {
    let isPlayerAdded = false;
    // Check for existing player
    if (this.getPlayer(clientId) === undefined) {
      // Add new player
      this.localPlayers[clientId] = player;
      // Set instance owner
      if (this.ownerClient === undefined) {
        this.setOwner(clientId);
      }
      isPlayerAdded = true;
    }
    return isPlayerAdded;
  }

  getPlayer(clientId) {
    return this.localPlayers[clientId];
  }

  getAllPlayerIds() {
    return Object.keys(this.localPlayers);
  }

  getAllPlayers() {
    return Object.values(this.localPlayers);
  }

  getAllRemotePlayers(excludeClientId) {
    const remotePlayers = this.getAllPlayerIds().filter((clientId) => {
      return clientId !== excludeClientId;
    });
    return remotePlayers.map((clientId) => {
      return this.getPlayer(clientId);
    });
  }

  getPlayerIdFirst() {
    let foundPlayerId = undefined;
    if (this.getPlayerCount() > 0) {
      foundPlayerId = this.getAllPlayerIds()[0];
    }
    return foundPlayerId;
  }

  getAllPlayerIds(ignoreClientIds = []) {
    return Object.keys(this.localPlayers).filter(
      (clientId) => !ignoreClientIds.includes(clientId)
    );
  }

  getPlayerCount() {
    return Object.keys(this.localPlayers).length;
  }

  addPatrol() {
    let isPatrolAdded = false;
    switch (this.roomIndex) {
      case ROOM_INDEX.ROOM_TOWN:
        {
          const newPatrol = new Patrol(
            this.availablePatrolId,
            PATROL_ROUTE_TIME_TOWN
          );
          this.localPatrols[this.availablePatrolId] = newPatrol;
          ConsoleHandler.Log(
            `Patrol with ID ${newPatrol.patrolId} started traveling towards Town, remaining ${newPatrol.travelTime}`
          );
          isPatrolAdded = true;
        }
        break;
      case ROOM_INDEX.ROOM_FOREST:
        {
          const newPatrol = new Patrol(
            this.availablePatrolId,
            PATROL_ROUTE_TIME_FOREST
          );
          this.localPatrols[this.availablePatrolId] = newPatrol;
          ConsoleHandler.Log(
            `Patrol with ID ${newPatrol.patrolId} started traveling towards Forest, remaining ${newPatrol.travelTime}`
          );
          isPatrolAdded = true;
        }
        break;
    }
    if (++this.availablePatrolId >= MAX_PATROL_ID) {
      this.availablePatrolId = 0;
    }
    return isPatrolAdded;
  }

  getPatrol(patrolId) {
    return this.localPatrols[patrolId];
  }

  getAllPatrolIds() {
    return Object.keys(this.localPatrols);
  }

  getAllPatrols() {
    return Object.values(this.localPatrols);
  }

  getAllLocalPatrols() {
    return this.getAllPatrols().filter((patrol) => patrol.travelTime <= 0);
  }

  getPatrolCount() {
    const patrolIds = this.getAllPatrolIds();
    const arrivedPatrols = patrolIds.filter((patrolId) => {
      let isArrived = false;
      const patrol = this.getPatrol(patrolId);
      if (patrol !== undefined) {
        isArrived = patrol.travelTime <= 0;
      }
      return isArrived;
    });
    return arrivedPatrols.length;
  }

  updateLocalPatrols(passedTickTime) {
    let isPatrolsUpdated = false;
    const localPatrolIds = this.getAllPatrolIds();
    if (localPatrolIds.length <= 0) {
      const randomPatrolCount = GetRandomInt(
        MIN_PATROL_COUNT,
        MAX_PATROL_COUNT
      );
      for (let i = 0; i < randomPatrolCount; i++) {
        this.addPatrol();
      }
      isPatrolsUpdated = true;
    } else {
      localPatrolIds.forEach((patrolId) => {
        const patrol = this.getPatrol(patrolId);
        if (patrol !== undefined) {
          if (patrol.travelTime > 0) {
            patrol.travelTime = Math.max(0, patrol.travelTime - passedTickTime);
          } else {
            switch (patrol.aiState) {
              case AI_STATE.TRAVEL:
                {
                  patrol.aiState = AI_STATE.PATROL;
                  ConsoleHandler.Log(
                    `Patrol with ID ${patrolId} arrived to destination`
                  );
                  // Broadcast new state
                  const patrolState = new PatrolState(
                    this.instanceId,
                    patrolId,
                    patrol.aiState
                  );
                  this.networkHandler.broadcastPatrolState(
                    this.instanceId,
                    patrolState
                  );
                }
                break;
              case AI_STATE.PATROL:
                {
                  // Simulate patrol movements when game area is empty
                  if (this.ownerClient === undefined) {
                    if (patrol.aiState === AI_STATE.PATROL) {
                      patrol.routeTime -= passedTickTime;
                    }
                    if (patrol.routeTime <= 0) {
                      patrol.aiState = AI_STATE.PATROL_END;
                      ConsoleHandler.Log(
                        `Patrol with ID ${patrolId} left the area`
                      );
                      // Broadcast new state
                      const patrolState = new PatrolState(
                        this.instanceId,
                        patrolId,
                        patrol.aiState
                      );
                      this.networkHandler.broadcastPatrolState(
                        this.instanceId,
                        patrolState
                      );
                      this.removePatrol(patrolId);
                    }
                  }
                }
                break;
            }
          }
        }
      });
      isPatrolsUpdated = true;
    }
    return isPatrolsUpdated;
  }

  handlePatrolState(patrolState) {
    var isStateHandled = false;
    const patrol = this.getPatrol(patrolState.patrolId);
    if (patrol !== undefined) {
      patrol.aiState = patrolState.aiState;
      isStateHandled = true;
    }
    return isStateHandled;
  }

  removePatrol(patrolId) {
    let isPatrolRemoved = false;
    if (this.getPatrol(patrolId) !== undefined) {
      delete this.localPatrols[patrolId];
      isPatrolRemoved = true;
    }
    return isPatrolRemoved;
  }

  setOwner(clientId) {
    this.ownerClient = clientId;
    // If owner leaves, run clean up
    if (clientId === undefined) {
      this.onOwnerLeave();
    }
  }

  resetOwner() {
    let isOwnerReset = false;
    if (this.getPlayerCount() > 0) {
      const playerId = this.getPlayerIdFirst();
      if (playerId !== undefined) {
        this.setOwner(playerId);
        isOwnerReset = true;
      } else {
        this.setOwner(undefined);
        isOwnerReset = true;
      }
    } else {
      this.setOwner(undefined);
      isOwnerReset = true;
    }
    return isOwnerReset;
  }

  onOwnerLeave() {
    // Reset patrol states on chase and resume
    if (this.roomIndex !== ROOM_INDEX.ROOM_CAMP) {
      this.getAllPatrols().forEach((patrol) => {
        if (
          patrol.aiState === AI_STATE.CHASE ||
          patrol.aiState === AI_STATE.PATROL_RESUME
        ) {
          patrol.forceResumePatrolling();
        }
      });
    }
  }

  removePlayer(clientId) {
    let isPlayerRemoved = false;
    const player = this.getPlayer(clientId);
    if (player !== undefined) {
      // End active inventory stream
      const activeInventoryStream =
        this.containerHandler.getActiveInventoryStreamByClientId(clientId);
      if (activeInventoryStream !== undefined) {
        this.containerHandler.removeActiveInventoryStream(
          activeInventoryStream.inventoryId
        );
      }
      // Release container access
      const requestedContainer =
        this.containerHandler.getContainerByRequestingClientId(clientId);
      if (requestedContainer !== undefined) {
        requestedContainer.requestingClient = undefined;
      }

      delete this.localPlayers[clientId];
      isPlayerRemoved = true;
    }
    return isPlayerRemoved;
  }
}
