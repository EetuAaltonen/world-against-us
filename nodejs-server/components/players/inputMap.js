class InputMap {
  constructor(key_up = 0, key_down = 0, key_left = 0, key_right = 0) {
    this.key_up = key_up;
    this.key_down = key_down;
    this.key_left = key_left;
    this.key_right = key_right;
  }
}

module.exports = InputMap;
