class PlayerData {
  constructor(
    uuid,
    tick_time,
    position,
    vector_speed,
    input_map,
    primary_weapon
  ) {
    this.uuid = uuid;
    this.tick_time = tick_time;
    this.position = position;
    this.vector_speed = vector_speed;
    this.input_map = input_map;
    this.primary_weapon = primary_weapon;
  }
}

module.exports = PlayerData;
