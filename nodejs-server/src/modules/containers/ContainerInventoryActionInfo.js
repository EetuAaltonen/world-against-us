// TODO: Move and rename to InventoryActionInfo
export default class ContainerInventoryActionInfo {
  constructor(
    containerId,
    sourceGridIndex,
    targetGridIndex,
    isRotated,
    isKnown,
    item
  ) {
    this.containerId = containerId;
    this.sourceGridIndex = sourceGridIndex;
    this.targetGridIndex = targetGridIndex;
    this.isRotated = isRotated;
    this.isKnown = isKnown;
    this.item = item;
  }
}
