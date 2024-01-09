import FormatHashMapToJSONStructArray from "../formatting/FormatHashMapToJSONStructArray.js";

export default class InstanceSnapshot {
  constructor(instanceId, localPlayers, localPatrols) {
    this.instanceId = instanceId;
    this.localPlayers = localPlayers;
    this.localPlayerCount = this.localPlayers.length;
    this.localPatrols = localPatrols;
    this.localPatrolCount = this.localPatrols.length;
  }

  toJSONStruct() {
    const formatLocalPlayers = FormatHashMapToJSONStructArray(
      this.localPlayers
    );
    const arrivedPatrols = Object.values(this.localPatrols).filter(
      (patrolJSONObject) => patrolJSONObject.travelTime <= 0
    );
    const formatPatrols = FormatHashMapToJSONStructArray(arrivedPatrols);
    return {
      region_id: this.instanceId,
      local_players: formatLocalPlayers,
      arrived_patrols: formatPatrols,
    };
  }
}
