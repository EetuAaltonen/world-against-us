export default class DeviceInputMovement {
  constructor(keyUp, keyDown, keyLeft, keyRight) {
    this.keyUp = keyUp;
    this.keyDown = keyDown;
    this.keyLeft = keyLeft;
    this.keyRight = keyRight;
  }

  toJSONStruct() {
    return {
      key_up: this.keyUp,
      key_down: this.keyDown,
      key_left: this.keyLeft,
      key_right: this.keyRight,
    };
  }
}
