import Inventory from "../inventory/Inventory.js";

export default class Container {
  constructor(containerId) {
    this.containerId = containerId;
    this.inventory = new Inventory(containerId);
    // TODO: Restrict access from other clients while container is open
    //this.requestingClient = undefined;
  }

  toJSONStruct() {
    const formatInventory = this.inventory.toJSONStruct();
    return {
      container_id: this.containerId,
      inventory: formatInventory,
    };
  }
}
