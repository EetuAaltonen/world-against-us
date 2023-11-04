import ROOM_INDEX from "../constants/RoomIndex.js";
import Instance from "./Instance.js";

export default class InstanceHandler {
  constructor() {
    this.instances = {};
    this.campId = 0;
    this.nextInstanceId = 1;

    if (this.getInstance(this.campId) === undefined) {
      this.createDefaultCampInstance();
    }
  }

  createDefaultCampInstance() {
    this.instances[this.campId] = new Instance(ROOM_INDEX.ROOM_CAMP);
  }

  createInstance(roomIndex) {
    let createdInstanceId;
    if (this.isRoomIndexValid(roomIndex)) {
      const createdInstance = new Instance(roomIndex);
      createdInstanceId = this.nextInstanceId;
      this.instances[createdInstanceId] = createdInstance;
      this.nextInstanceId++;
    }
    return createdInstanceId;
  }

  getInstance(instanceId) {
    return this.instances[instanceId];
  }

  getInstanceIds() {
    return Object.keys(this.instances);
  }

  isRoomIndexValid(roomIndex) {
    return Object.values(ROOM_INDEX).includes(roomIndex);
  }

  fastTravelPlayer(
    clientId,
    sourceInstanceId,
    destinationRoomIndex,
    destinationInstanceId
  ) {
    let newInstanceId;
    const sourceInstance = this.instances[sourceInstanceId];
    if (sourceInstance !== undefined) {
      const player = sourceInstance.getPlayer(clientId);
      if (player !== undefined) {
        if (this.isRoomIndexValid(destinationRoomIndex))
          if (this.removePlayerFromInstance(clientId, sourceInstanceId)) {
            if (destinationRoomIndex === ROOM_INDEX.ROOM_CAMP) {
              newInstanceId = this.addPlayerToDefaultInstance(clientId, player);
            } else {
              const priorityInstanceId =
                sourceInstanceId === destinationInstanceId
                  ? undefined
                  : destinationInstanceId;
              newInstanceId = this.addPlayerToInstance(
                clientId,
                destinationRoomIndex,
                player,
                priorityInstanceId
              );
              if (newInstanceId !== undefined) {
                player.resetPosition();
              }
            }
          }
      }
    }
    return newInstanceId;
  }

  addPlayerToDefaultInstance(clientId, player) {
    const instanceId = this.addPlayerToInstance(
      clientId,
      ROOM_INDEX.ROOM_CAMP,
      player,
      this.campId
    );
    return instanceId;
  }

  addPlayerToInstance(
    clientId,
    roomIndex,
    player,
    priorityInstanceId = undefined
  ) {
    let instanceId;
    if (priorityInstanceId !== undefined) {
      const instance = this.getInstance(priorityInstanceId);
      if (instance !== undefined) {
        if (instance.roomIndex == roomIndex) {
          instance.addPlayer(clientId, player);
          instanceId = priorityInstanceId;
        }
      }
    } else {
      const createdInstanceId = this.createInstance(roomIndex);
      if (createdInstanceId !== undefined) {
        const createdInstance = this.instances[createdInstanceId];
        if (createdInstance.addPlayer(clientId, player)) {
          createdInstance.setOwner(clientId);
          instanceId = createdInstanceId;
        }
      }
    }
    return instanceId;
  }

  removePlayerFromInstance(clientId, instanceId = undefined) {
    let isPlayerRemoved = false;
    if (instanceId !== undefined) {
      const instance = this.getInstance(instanceId);
      if (instance !== undefined) {
        if (instance.removePlayer(clientId)) {
          if (!this.checkInstanceRelease(instanceId)) {
            if (instance.ownerClient == clientId) {
              if (!instance.resetOwner()) {
                // TODO: Proper error handling
                console.log(
                  `Failed to reset owner for an instance with ID: ${instanceId}`
                );
              }
            }
          }
          isPlayerRemoved = true;
        }
      }
    } else {
      const instanceIds = this.getInstanceIds();
      const instanceCount = instanceIds.length;
      for (let i = 0; i < instanceCount; i++) {
        const instanceId = instanceIds[i];
        const instance = this.getInstance(instanceId);
        if (instance.getPlayer(clientId) !== undefined) {
          if (instance.removePlayer(clientId)) {
            if (!this.checkInstanceRelease(instanceId)) {
              if (instance.ownerClient == clientId) {
                if (!instance.resetOwner()) {
                  // TODO: Proper error handling
                  console.log(
                    `Failed to reset owner for an instance with ID: ${instanceId}`
                  );
                }
              }
            }
            isPlayerRemoved = true;
            break;
          }
        }
      }
    }
    return isPlayerRemoved;
  }

  checkInstanceRelease(instanceId) {
    let isInstanceReleased = false;
    const instance = this.getInstance(instanceId);
    if (instance !== undefined) {
      if (
        instance.getPlayerCount() <= 0 &&
        instance.roomIndex !== ROOM_INDEX.ROOM_CAMP
      ) {
        if (this.deleteInstance(instanceId)) {
          isInstanceReleased = true;
        } else {
          // TODO: Proper error handling
          console.log("Failed to delete instance with ID: " + instanceId);
        }
      }
    }
    return isInstanceReleased;
  }

  deleteInstance(instanceId) {
    let isInstanceDeleted = false;
    if (this.getInstance(instanceId) !== undefined) {
      delete this.instances[instanceId];
      isInstanceDeleted = true;
    }
    return isInstanceDeleted;
  }
}
