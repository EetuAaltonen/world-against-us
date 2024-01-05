import Vector2 from "../math/Vector2.js";
import DeviceInputMovement from "../device_input/DeviceInputMovement.js";

export default class Player {
  constructor(networkId, name) {
    this.networkId = networkId;
    this.name = name;
    this.position = new Vector2(0, 0);
    this.inputMovement = new DeviceInputMovement(0, 0, 0, 0);
  }

  toJSONStruct() {
    const formatPosition = this.position.toJSONStruct();
    return {
      network_id: this.networkId,
      name: this.name,
      position: formatPosition,
    };
  }

  resetPosition() {
    this.position.x = 0;
    this.position.y = 0;
  }
}
