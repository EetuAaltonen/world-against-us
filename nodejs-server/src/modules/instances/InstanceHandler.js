import ROOM_INDEX from "./RoomIndex.js";
import WORLD_MAP_LOCATION_HIERARCHY from "../world_map/WorldMapLocationHierarchy.js";
import Instance from "./Instance.js";

const CAMP_STORAGE_CONTAINER_ID = "camp_storage_container";

export default class InstanceHandler {
  constructor(networkHandler) {
    this.networkHandler = networkHandler;
    this.instances = {};
    this.campId = 0;
    this.nextInstanceId = 1;

    this.createDefaultCampInstance();
  }

  createDefaultCampInstance() {
    let isInstanceCreated = true;
    const campInstance = new Instance(
      this.campId,
      ROOM_INDEX.ROOM_CAMP,
      this.networkHandler
    );
    campInstance.containerHandler.initContainer(CAMP_STORAGE_CONTAINER_ID);
    this.instances[this.campId] = campInstance;
    return isInstanceCreated;
  }

  getDefaultCampStorageContainer() {
    let campStorageContainer;
    const campInstance = this.getInstance(this.campId);
    if (campInstance !== undefined) {
      campStorageContainer = campInstance.containerHandler.getContainerById(
        CAMP_STORAGE_CONTAINER_ID
      );
    }
    return campStorageContainer;
  }

  createInstance(roomIndex) {
    let createdInstanceId;
    if (this.isRoomIndexValid(roomIndex)) {
      const createdInstance = new Instance(
        this.nextInstanceId,
        roomIndex,
        this.networkHandler
      );
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

  update(passedTickTime) {
    let isUpdated = true;
    this.getInstanceIds().forEach((instanceId) => {
      const instance = this.getInstance(instanceId);
      if (instance !== undefined) {
        if (!instance.update(passedTickTime)) {
          isUpdated = false;
        }
      }
    });
    return isUpdated;
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
        if (this.isRoomIndexValid(destinationRoomIndex)) {
          if (destinationRoomIndex === ROOM_INDEX.ROOM_CAMP) {
            if (this.removePlayerFromInstance(clientId, sourceInstanceId)) {
              newInstanceId = this.addPlayerToDefaultInstance(clientId, player);
            }
          } else {
            let priorityInstanceId =
              sourceInstanceId === destinationInstanceId
                ? undefined
                : destinationInstanceId;
            // This logic supports only 1-level of parent-child hierarchy
            // No sub-instances with sub-instances
            if (sourceInstance.parentInstanceId === undefined) {
              if (priorityInstanceId === undefined) {
                this.getInstanceIds().forEach((instanceId) => {
                  const instance = this.getInstance(instanceId);
                  if (
                    instance.parentInstanceId === sourceInstanceId &&
                    instance.roomIndex === destinationRoomIndex
                  ) {
                    priorityInstanceId = instanceId;
                  }
                });
              }
            }
            newInstanceId = this.addPlayerToInstance(
              clientId,
              destinationRoomIndex,
              player,
              priorityInstanceId
            );
            if (newInstanceId !== undefined) {
              // Set instance hierarchy parenthood for new instances
              if (priorityInstanceId === undefined) {
                this.setInstanceParenthood(
                  newInstanceId,
                  destinationRoomIndex,
                  sourceInstanceId
                );
              }
              if (this.removePlayerFromInstance(clientId, sourceInstanceId)) {
                // Reset player position
                player.resetPosition();

                console.log(
                  `Player fast-traveled from ${sourceInstanceId} to ${newInstanceId}`
                );
              }
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
        if (instance.roomIndex === roomIndex) {
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

  setInstanceParenthood(childInstanceId, roomIndex, parentInstanceId) {
    const parentInstance = this.getInstance(parentInstanceId);
    const parentInstanceHierarchy =
      WORLD_MAP_LOCATION_HIERARCHY[parentInstance.roomIndex];
    if (Object.keys(parentInstanceHierarchy).includes(roomIndex)) {
      const childInstance = this.getInstance(childInstanceId);
      if (childInstance !== undefined) {
        childInstance.parentInstanceId = parentInstanceId;
      }
    }
  }

  removePlayerFromInstance(clientId, instanceId = undefined) {
    let isPlayerRemoved = false;
    if (instanceId !== undefined) {
      const instance = this.getInstance(instanceId);
      if (instance !== undefined) {
        if (instance.removePlayer(clientId)) {
          if (!this.checkInstanceRelease(instanceId)) {
            if (instance.ownerClient === clientId) {
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
              if (instance.ownerClient === clientId) {
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
    if (instanceId !== this.campId) {
      const instance = this.getInstance(instanceId);
      if (instance !== undefined) {
        // Check if instance is sub-instance
        if (instance.parentInstanceId === undefined) {
          let totalPlayerCount = instance.getPlayerCount();
          const subInstanceIds = this.getInstanceIds().filter((id) => {
            const instance = this.getInstance(id);
            if (instance !== undefined) {
              return instance.parentInstanceId === instanceId;
            }
            return false;
          });
          subInstanceIds.forEach((subInstanceId) => {
            totalPlayerCount +=
              this.getInstance(subInstanceId).getPlayerCount();
          });

          if (totalPlayerCount <= 0) {
            if (this.deleteInstance(instanceId)) {
              console.log(`Instance deleted: ${instanceId}`);
              // Delete sub-instances
              subInstanceIds.forEach((subInstanceId) => {
                this.deleteInstance(subInstanceId);
                console.log(`Sbu-instance deleted: ${subInstanceId}`);
              });
              isInstanceReleased = true;
            } else {
              // TODO: Proper error handling
              console.log("Failed to delete instance with ID: " + instanceId);
            }
          }
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
