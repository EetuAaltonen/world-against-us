export default class InventoryStream {
  constructor(
    inventoryId,
    streamItemLimit,
    isStreamSending,
    streamCurrentIndex,
    streamEndIndex
  ) {
    this.inventoryId = inventoryId;
    this.streamItemLimit = streamItemLimit;
    this.isStreamSending = isStreamSending;
    this.streamCurrentIndex = streamCurrentIndex;
    this.streamEndIndex = streamEndIndex;

    this.requestingClient = undefined;
    this.targetInventory = undefined;
  }

  fetchNextInventoryStreamItems() {
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
