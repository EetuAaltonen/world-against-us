export default class Vector2 {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  toJSONStruct() {
    return {
      X: this.x,
      Y: this.y,
    };
  }
}
