export default class PatrolSnapshot {
  constructor(patrolId, routeProgress, position) {
    this.patrolId = patrolId;
    this.routeProgress = routeProgress;
    this.position = position;
  }

  toJSONStruct() {
    var formatPosition = this.position.toJSONStruct();
    return {
      patrol_id: this.patrolId,
      route_progress: this.routeProgress,
      position: formatPosition,
    };
  }
}
