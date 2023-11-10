import Inventory from "../inventory/Inventory.js";

export default class Container {
  constructor(containerId) {
    this.containerId = containerId;
    this.inventory = new Inventory(containerId);
  }

  }
}
