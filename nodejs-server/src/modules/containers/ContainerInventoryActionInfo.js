export default class ContainerInventoryActionInfo {
  constructor(
    containerId,
    sourceGridIndex,
    targetGridIndex,
    isRotated,
    isKnown
  ) {
    this.containerId = containerId;
    this.sourceGridIndex = sourceGridIndex;
    this.targetGridIndex = targetGridIndex;
    this.isRotated = isRotated;
    this.isKnown = isKnown;
  }
}
