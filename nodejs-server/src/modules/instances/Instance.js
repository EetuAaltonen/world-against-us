import ROOM_INDEX from "./RoomIndex.js";
import AI_STATE from "../patrols/AIState.js";

import ContainerHandler from "../containers/ContainerHandler.js";
import Patrol from "../patrols/Patrol.js";
import GetRandomInt from "../math/GetRandomInt.js";
import PatrolState from "../patrols/PatrolState.js";

import FormatHashMapToJSONStructArray from "../formatting/FormatHashMapToJSONStructArray.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

const PATROL_ROUTE_TIME_TOWN = 270000; // ~4.5min
const MAX_PATROL_ID = 100;
const MIN_PATROL_COUNT = 1;
const MAX_PATROL_COUNT = 2;

export default class Instance {
  constructor(instanceId, roomIndex, networkHandler) {
    this.instanceId = instanceId;
    this.roomIndex = roomIndex;
    this.networkHandler = networkHandler;
    this.parentInstanceId = undefined;
    this.ownerClient = undefined;
    this.localPlayers = {};
    this.localPatrols = {}; // TODO: local patrols
    this.containerHandler = new ContainerHandler(this.networkHandler);

    this.availablePatrolId = 0;
  }

  toJSONStruct() {
    const formatParentRegionId = this.parentInstanceId ?? -1;
    const formatOwnerClient = this.ownerClient ?? UNDEFINED_UUID;
    // TODO: Local players
    const formatPatrols = FormatHashMapToJSONStructArray(this.localPatrols);
    const arrivedPatrols = formatPatrols.filter(
      (patrolJSONObject) => patrolJSONObject.travel_time <= 0
    );
    return {
      region_id: this.instanceId,
      room_index: this.roomIndex,
      parent_region_id: formatParentRegionId,
      owner_client: formatOwnerClient,
      arrived_patrols: arrivedPatrols,
      // TODO: Sync players
    };
  }

  update(passedTickTime) {
    let isUpdated = true;
    if (this.roomIndex === ROOM_INDEX.ROOM_CAMP) {
      // TODO: Update the Camp
    } else {
      const localPatrolIds = this.getAllPatrolIds();
      if (localPatrolIds.length <= 0) {
        const randomPatrolCount = GetRandomInt(
          MIN_PATROL_COUNT,
          MAX_PATROL_COUNT
        );
        for (let i = 0; i < randomPatrolCount; i++) {
          this.addPatrol();
        }
      } else {
        localPatrolIds.forEach((patrolId) => {
          const patrol = this.getPatrol(patrolId);
          if (patrol !== undefined) {
            if (patrol.travelTime > 0) {
              patrol.travelTime -= passedTickTime;
            } else {
              switch (patrol.aiState) {
                case AI_STATE.QUEUE:
                  {
                    patrol.aiState = AI_STATE.PATROL;
                    console.log(
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
                    if (patrol.aiState === AI_STATE.PATROL) {
                      patrol.routeTime -= passedTickTime;
                    }
                    if (patrol.routeTime <= 0) {
                      patrol.aiState = AI_STATE.PATROL_END;
                      console.log(`Patrol with ID ${patrolId} left the area`);
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
                  break;
              }
            }
          }
        });
      }
    }
    return isUpdated;
  }

  addPlayer(clientId, player) {
    let isPlayerAdded = false;
    if (this.getPlayer(clientId) === undefined) {
      this.localPlayers[clientId] = player;
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

  getPlayerIdFirst() {
    let foundPlayerId = undefined;
    if (this.getPlayerCount > 0) {
      foundPlayerId = Object.keys(this.localPlayers)[0];
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
          console.log(
            `Patrol with ID ${newPatrol.patrolId} started traveling, remaining ${newPatrol.travelTime}`
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

  removePlayer(clientId) {
    let isPlayerRemoved = false;
    if (this.getPlayer(clientId) !== undefined) {
      delete this.localPlayers[clientId];
      isPlayerRemoved = true;
    }
    return isPlayerRemoved;
  }
}
