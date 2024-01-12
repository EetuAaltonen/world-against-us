export default class InstanceSnapshot {
  constructor(instanceId, localPlayers, localPatrols) {
    this.instanceId = instanceId;
    this.localPlayers = localPlayers;
    this.localPlayerCount = this.localPlayers.length;
    this.localPatrols = localPatrols;
    this.localPatrolCount = this.localPatrols.length;
  }
}
