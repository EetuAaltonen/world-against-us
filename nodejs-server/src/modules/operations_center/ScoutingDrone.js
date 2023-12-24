import Vector2 from "../math/Vector2.js";

export default class ScoutingDrone {
  constructor(instanceId) {
    this.instanceId = instanceId;
    this.position = new Vector2(0, 0);
  }

  toJSONStruct() {
    const formatPosition = this.position.toJSONStruct();
    return {
      region_id: this.instanceId,
      position: formatPosition,
    };
  }
}
