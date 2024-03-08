export default class PatrolState {
  constructor(
    instanceId,
    patrolId,
    aiState,
    routeProgress,
    position,
    targetNetworkId
  ) {
    this.instanceId = instanceId;
    this.patrolId = patrolId;
    this.aiState = aiState;
    this.routeProgress = routeProgress;
    this.position = position;
    this.targetNetworkId = targetNetworkId;
  }
}
