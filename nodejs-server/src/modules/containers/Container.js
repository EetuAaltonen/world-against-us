import Inventory from "../inventory/Inventory.js";

export default class Container {
  constructor(containerId, inventoryType) {
    this.containerId = containerId;

    this.inventory = new Inventory(containerId, inventoryType);
  }
}
