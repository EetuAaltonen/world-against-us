const Inventory = require("../inventory/inventory");
const InventorySize = require("../inventory/inventorySize");

class Container {
  constructor(containerId, type = "temp", size = new InventorySize(10, 10)) {
    this.inventory = new Inventory(containerId, type, size);
  }

  AddItem(item, gridIndex = undefined, known = true) {
    this.inventory.Add(item, gridIndex, known);
  }

  GetItemByIndex(gridIndex) {
    return this.inventory.GetByIndex(gridIndex);
  }

  GetAllItems() {
    return this.inventory.GetAll();
  }

  IdentifyItemByIndex(gridIndex) {
    this.inventory.IdentifyByIndex(gridIndex);
  }

  MoveAndRotateItemByIndex(gridIndex, newGridIndex, isRotated) {
    this.inventory.MoveAndRotateByIndex(gridIndex, newGridIndex, isRotated);
  }

  MoveItemByIndex(gridIndex, newGridIndex) {
    this.inventory.MoveByIndex(gridIndex, newGridIndex);
  }

  RotateItemByIndex(gridIndex, isRotated) {
    this.inventory.RotateByIndex(gridIndex, isRotated);
  }

  DeleteItemByIndex(gridIndex) {
    this.inventory.DeleteByIndex(gridIndex);
  }
}

module.exports = Container;
