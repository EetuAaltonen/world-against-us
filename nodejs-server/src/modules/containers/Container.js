import Inventory from "../inventory/Inventory.js";

export default class Container {
  constructor(containerId) {
    this.containerId = containerId;
    this.inventory = new Inventory(containerId);
  }

  toJSONObject() {
    const formatInventory = this.inventory.toJSONObject();
    return {
      container_id: this.containerId,
      inventory: formatInventory,
    };
  }
}
