export default class PlayerInfo {
  constructor(playerName, instanceId, roomIndex) {
    this.playerName = playerName;
    this.instanceId = instanceId;
    this.roomIndex = roomIndex;
  }

  toJSONStruct() {
    return {
      player_name: this.playerName,
      instance_id: this.instanceId,
      room_index: this.roomIndex,
    };
  }
}
