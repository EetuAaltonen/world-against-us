const Container = require("../containers/container");
const InventorySize = require("../inventory/inventorySize");

class ContainersService {
  constructor(itemsDatabase) {
    this.containers = {};
    this.itemsDatabase = itemsDatabase;
  }

  AddContainer(
    containerId,
    type = "temp",
    size = new InventorySize(10, 10),
    items = [],
    isContentKnown = true
  ) {
    const newContainer = new Container(containerId, type, size, items);
    this.containers[containerId] = newContainer;

    items.forEach((item) => {
      newContainer.AddItem(structuredClone(item), undefined, isContentKnown);
    });
  }

  GetContainerById(containerId) {
    return this.containers[containerId];
  }

  DeleteContainerById(containerId) {
    delete this.containers[containerId];
  }
}

module.exports = ContainersService;
