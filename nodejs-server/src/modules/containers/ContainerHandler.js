import Container from "./Container.js";

export default class ContainerHandler {
  constructor() {
    // TODO: Replace activeInventoryStream with activeInventoryStreams[containerId]
    this.activeInventoryStream = undefined;
    this.containers = {};
  }

  initContainer(containerId) {
    let isContainerInitialized = true;
    this.containers[containerId] = new Container(containerId);
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
}
