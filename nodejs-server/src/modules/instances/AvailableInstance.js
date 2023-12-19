export default class AvailableInstance {
  constructor(instanceId, roomIndex, playerCount, patrolCount) {
    this.instanceId = instanceId;
    this.roomIndex = roomIndex;
    this.playerCount = playerCount;
    this.patrolCount = patrolCount;
  }

  toJSONStruct() {
    return {
      instance_id: this.instanceId,
      room_index: this.roomIndex,
      player_count: this.playerCount,
      patrol_count: this.patrolCount,
    };
  }
}
