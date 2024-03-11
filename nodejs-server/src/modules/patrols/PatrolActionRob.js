export default class PatrolActionRob {
  constructor(instanceId, patrolId, targetNetworkId, targetPlayerTag) {
    this.instanceId = instanceId;
    this.patrolId = patrolId;
    this.targetNetworkId = targetNetworkId;
    this.targetPlayerTag = targetPlayerTag;
  }

  toJSONStruct() {
    return {
      region_id: this.instanceId,
      patrol_id: this.patrolId,
      target_network_id: this.targetNetworkId,
      target_player_tag: this.targetPlayerTag,
    };
  }
}
