import Vector2 from "../math/Vector2.js";
import DeviceInputMovement from "../device_input/DeviceInputMovement.js";

export default class Player {
  constructor(name) {
    this.name = name;
    this.position = new Vector2(0, 0);
    this.inputMovement = new DeviceInputMovement(0, 0, 0, 0);
  }

  toJSONStruct() {
    const formatPosition = this.position.toJSONStruct();
    return {
      name: this.name,
      position: formatPosition,
    };
  }

  resetPosition() {
    this.position.x = 0;
    this.position.y = 0;
  }
}
