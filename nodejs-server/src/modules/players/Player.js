import Vector2 from "../math/Vector2.js";

export default class Player {
  constructor(name) {
    this.name = name;
    this.position = new Vector2(0, 0);
  }

  move(x, y) {
    this.position.x = x;
    this.position.y = y;
  }
}
