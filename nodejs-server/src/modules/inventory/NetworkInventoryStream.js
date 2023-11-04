export default class NetworkInventoryStream {
  constructor(
    targetContainerId,
    targetInstancePosition,
    streamItemLimit,
    isStreamSending,
    streamCurrentIndex,
    streamEndIndex
  ) {
    this.targetContainerId = targetContainerId;
    // TODO: Remove container location
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
