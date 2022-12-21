const Size = require("../math/size");

class Item {
  constructor(
    name,
    icon,
    size,
    type,
    weight,
    max_stack,
    base_price,
    description,

    quantity = 1,
    metadata = -4,
    isRotated = false,
    known = true,
    grid_index = -4
  ) {
    this.name = name;
    this.icon = icon;
    this.size = new Size(size.w, size.h);
    this.type = type;
    this.weight = weight;
    this.max_stack = max_stack;
    this.base_price = base_price;
    this.description = description;

    this.quantity = quantity;
    this.metadata = metadata;
    this.isRotated = isRotated;
    this.known = known;

    this.grid_index = grid_index;
  }

  Rotate() {
    if (size.w != size.h) {
      isRotated = !isRotated;
      // Swap width and height
      size = new Size(size.h, size.w);
    }
  }
}

module.exports = Item;
