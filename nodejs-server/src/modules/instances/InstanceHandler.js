import ROOM_INDEX from "../constants/RoomIndex.js";
import Instance from "./Instance.js";

export default class InstanceHandler {
  constructor() {
    this.instances = {};
    this.campId = 0;
    this.nextId = 1;

    if (this.getInstance(this.campId) === undefined) {
      this.createDefaultCampInstance();
    }
  }

  createDefaultCampInstance() {
    this.instances[this.campId] = new Instance(ROOM_INDEX.ROOM_CAMP);
  }

  createInstance(roomIndex) {
    let createdInstanceId;
    if (Object.keys(this.instances).includes(roomIndex)) {
      const createdInstance = new Instance(roomIndex);
      createdInstanceId = this.nextId;
      this.instances[createdInstanceId] = createdInstance;
      this.nextIndex++;
      console.log("createdInstanceId: " + createdInstanceId);
    }
    return createdInstanceId;
  }

  getInstance(instanceId) {
    return this.instances[instanceId];
  }

  getInstanceIds() {
    return Object.keys(this.instances);
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
      const createdInstance = this.instances[createdInstanceId];
      if (createdInstance.addPlayer(clientId, player)) {
        createdInstance.setOwner(clientId);
        instanceId = createdInstanceId;
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
          isPlayerRemoved = true;
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
        }
      }
    } else {
      const instanceIds = this.getInstanceIds();
      const instanceCount = instanceIds.length;
      for (var i = 0; i < instanceCount; i++) {
        const instanceId = instanceIds[0];
        const instance = this.getInstance(instanceId);
        if (instance.getPlayer(clientId) !== undefined) {
          if (instance.removePlayer(clientId)) {
            isPlayerRemoved = true;
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
          }
          break;
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

  resetInstanceOwner(instance) {
    return instance.resetOwner();
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
