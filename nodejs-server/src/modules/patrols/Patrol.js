import AI_STATE from "./AIState.js";
import GetRandomInt from "../math/GetRandomInt.js";

const MIN_TRAVEL_TIME = 4000;
const MAX_TRAVEL_TIME = 20000;

export default class Patrol {
  constructor(patrolId, routeTime) {
    this.patrolId = patrolId;
    this.totalRouteTime = routeTime;
    this.routeTime = routeTime;
    this.aiState = AI_STATE.QUEUE;
    this.travelTime = GetRandomInt(MIN_TRAVEL_TIME, MAX_TRAVEL_TIME);
  }

  toJSONObject() {
    console.log(1 - this.routeTime / this.totalRouteTime);
    var formatScaledRouteProgress = Math.round(
      (1 - this.routeTime / this.totalRouteTime) * 1000
    );
    return {
      patrol_id: this.patrolId,
      ai_state: this.aiState,
      travel_time: Math.max(0, this.travelTime),
      scaled_route_progress: formatScaledRouteProgress,
    };
  }
}
