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

  FetchNextItems() {
    let items = [];
    if (this.targetInventory !== undefined) {
      const lastItemIndex = this.streamCurrentIndex + this.streamItemLimit;
      const itemGridIndexKeys =
        this.targetInventory.getItemGridIndexKeysByRange(
          this.streamCurrentIndex,
          lastItemIndex
        );
      itemGridIndexKeys.forEach((gridIndexKey) => {
        const item = this.targetInventory.getItemByGridIndexKey(gridIndexKey);
        if (item !== undefined) {
          items.push(item);
        }
      });
      this.streamCurrentIndex += itemGridIndexKeys.length;
    }
    return items;
  }
}
