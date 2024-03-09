import AI_STATE_BANDIT from "./AIStateBandit.js";

import GetRandomInt from "../math/GetRandomInt.js";
import Vector2 from "../math/Vector2.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";
const MIN_TRAVEL_TIME = 4000;
const MAX_TRAVEL_TIME = 20000;
const FIXED_POINT_PERCENT_PRECISION = 1000;

export default class Patrol {
  constructor(patrolId, instanceId, routeTime) {
    this.patrolId = patrolId;
    this.instanceId = instanceId;
    this.totalRouteTime = routeTime;
    this.routeTime = this.totalRouteTime;
    this.routeProgress = 0;
    this.aiState = AI_STATE_BANDIT.TRAVEL;
    this.travelTime = GetRandomInt(MIN_TRAVEL_TIME, MAX_TRAVEL_TIME);
    this.position = new Vector2(0, 0);
    this.targetNetworkId = UNDEFINED_UUID;
  }

  toJSONStruct() {
    var formatPosition = this.position.toJSONStruct();
    return {
      patrol_id: this.patrolId,
      region_id: this.instanceId,
      ai_state: this.aiState,
      travel_time: this.travelTime,
      route_progress: this.routeProgress,
      position: formatPosition,
      target_network_id: this.targetNetworkId,
    };
  }

  getRouteProgress() {
    return 1 - this.routeTime / this.totalRouteTime;
  }

  getScaledRouteProgress() {
    return Math.round(
      (1 - this.routeTime / this.totalRouteTime) * FIXED_POINT_PERCENT_PRECISION
    );
  }

  forceResumePatrolling() {
    this.aiState = AI_STATE_BANDIT.PATROL;
    this.position.x = 0;
    this.position.y = 0;
  }
}
