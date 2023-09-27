class InventoryService {
  constructor() {
    this.inventory = {};
  }

  AddInventory(uuid) {
    this.inventory[uuid] = player;
  }

  GetInventoryByPlayerId(uuid) {
    return this.inventory[uuid];
  }

  DeleteInventoryByPlayerId(uuid) {
    delete this.inventory[uuid];
  }
}

module.exports = InventoryService;
