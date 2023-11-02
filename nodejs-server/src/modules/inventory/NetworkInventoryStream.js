export default class NetworkInventoryStream {
  constructor(
    instanceId,
    targetContainerId,
    targetInstancePosition,
    streamItemLimit,
    isStreamSending,
    streamCurrentIndex,
    streamEndIndex
  ) {
    this.instanceId = instanceId;
    this.targetContainerId = targetContainerId;
    this.targetInstancePosition = targetInstancePosition;
    this.targetInventory = undefined;
    this.streamItemLimit = streamItemLimit;
    this.isStreamSending = isStreamSending;
    this.streamCurrentIndex = streamCurrentIndex;
    this.streamEndIndex = streamEndIndex;
  }

  FetchItemsToStream() {
    var items = [];
    if (this.targetInventory !== undefined) {
      let lastItemIndex = this.streamCurrentIndex + this.streamItemLimit;
      const itemIndices = Object.keys(this.targetInventory).slice(
        this.streamCurrentIndex,
        lastItemIndex
      );
      itemIndices.forEach((key) => {
        const item = this.targetInventory[key];
        if (item !== undefined) {
          items.push(item);
        }
      });

      this.streamCurrentIndex += itemIndices.length;
    }
    return items;
  }
}
