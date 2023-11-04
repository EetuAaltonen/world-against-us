export default class Inventory {
  constructor(inventoryId, type) {
    this.inventoryId = inventoryId;
    this.type = type;

    this.items = {};
  }

  addItem(item) {
    let isItemAdded = false;
    if (item !== undefined) {
      const existentItem = this.getItemByGridIndex(item.grid_index);
      if (existentItem === undefined) {
        const gridIndexKey = this.formatGridIndex(item.grid_index);
        if (gridIndexKey !== undefined) {
          this.items[gridIndexKey] = item;
          isItemAdded = true;
        }
      }
    }
    return isItemAdded;
  }

  addItems(items) {
    let isItemsAdded = true;
    // TODO: Collect items' grid indices to array
    // and rollback if any of add process fails
    if (items !== undefined) {
      items.forEach((item) => {
        if (isItemsAdded) {
          if (!this.addItem(item)) {
            isItemsAdded = false;
            console.log(`Unable to add item ${item.name} to inventory`);
          }
        }
      });
    }
    return isItemsAdded;
  }

  getItemByGridIndex(gridIndex) {
    let item;
    const gridIndexKey = this.formatGridIndex(gridIndex);
    if (gridIndexKey !== undefined) {
      item = this.items[gridIndexKey];
    }
    return item;
  }

  getItemCount() {
    return Object.keys(this.items).length;
  }

  stackItem() {}

  identifyItemByGridIndex() {}

  rotateItemByGridIndex(gridIndex, newRotation) {
    let isItemRotated = false;
    const item = this.getContainerItemByGridIndex(gridIndex);
    if (item !== undefined) {
      item.is_rotated = newRotation;
      isItemRotated = true;
    }
    return isItemRotated;
  }

  removeItemByGridIndex(gridIndex) {
    let isItemRemoved = false;
    if (this.getItemByGridIndex(gridIndex) !== undefined) {
      const gridIndexKey = this.formatGridIndex(gridIndex);
      if (gridIndexKey !== undefined) {
        delete this.items[gridIndexKey];
        isItemRemoved = true;
      }
    }
    return isItemRemoved;
  }

  removeAllItems() {
    let isAllItemsRemoved = true;
    this.items = {};
    return isAllItemsRemoved;
  }

  formatGridIndex(gridIndex) {
    let formatGridIndex;
    if (gridIndex !== undefined) {
      if (gridIndex.col !== undefined && gridIndex.row !== undefined) {
        formatGridIndex = `${gridIndex.col}-${gridIndex.row}`;
      }
    }
    return formatGridIndex;
  }
}
