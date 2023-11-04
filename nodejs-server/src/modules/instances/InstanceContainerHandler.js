import Container from "../containers/Container.js";

export default class InstanceContainerHandler {
  constructor() {
    // TODO: Replace activeInventoryStream with activeInventoryStreams[containerId]
    this.activeInventoryStream = undefined;
    this.containers = {};
  }

  initContainer(containerId, inventoryType) {
    let isContainerInitialized = true;
    this.containers[containerId] = new Container(containerId, inventoryType);
    return isContainerInitialized;
  }

  getContainerById(containerId) {
    return this.containers[containerId];
  }

  getContainerContentCountById(containerId) {
    let contentCount = -1;
    const container = this.getContainerById(containerId);
    if (container !== undefined) {
      contentCount = container.inventory.getItemCount();
    }
    return contentCount;
  }

  addContainerItem(containerId, item) {
    let isItemAdded = false;
    if (item !== undefined) {
      const container = this.getContainerById(containerId);
      if (container !== undefined) {
        isItemAdded = container.addItem(item);
      }
    }
    return isItemAdded;
  }
}
