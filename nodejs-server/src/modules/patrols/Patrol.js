import AI_STATE from "./AIState.js";

import GetRandomInt from "../math/GetRandomInt.js";
import Vector2 from "../math/Vector2.js";

const MIN_TRAVEL_TIME = 4000;
const MAX_TRAVEL_TIME = 20000;
const FIXED_POINT_PERCENT_PRECISION = 1000;

export default class Patrol {
  constructor(patrolId, routeTime) {
    this.patrolId = patrolId;
    this.totalRouteTime = routeTime;
    this.routeTime = routeTime;
    this.aiState = AI_STATE.TRAVEL;
    this.travelTime = GetRandomInt(MIN_TRAVEL_TIME, MAX_TRAVEL_TIME);

    this.localPosition = new Vector2(0, 0);
  }

  toJSONStruct() {
    var formatScaledRouteProgress = this.getScaledRouteProgress();
    var formatLocalPosition = this.localPosition.toJSONStruct();
    return {
      patrol_id: this.patrolId,
      ai_state: this.aiState,
      travel_time: this.travelTime,
      scaled_route_progress: formatScaledRouteProgress,
      local_position: formatLocalPosition,
    };
  }

  getScaledRouteProgress() {
    return Math.round(
      (1 - this.routeTime / this.totalRouteTime) * FIXED_POINT_PERCENT_PRECISION
    );
  }

  forceResumePatrolling() {
    this.aiState = AI_STATE.PATROL;
    this.localPosition.x = 0;
    this.localPosition.y = 0;
  }
}
