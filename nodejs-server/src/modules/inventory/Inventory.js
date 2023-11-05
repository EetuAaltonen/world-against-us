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
      if (Array.isArray(items)) {
        items.forEach((item) => {
          if (isItemsAdded) {
            if (!this.addItem(item)) {
              isItemsAdded = false;
              console.log(`Unable to add item ${item.name} to inventory`);
            }
          }
        });
      } else {
        isItemsAdded = false;
      }
    }
    return isItemsAdded;
  }

  getItemByGridIndex(gridIndex) {
    let item;
    const gridIndexKey = this.formatGridIndex(gridIndex);
    if (gridIndexKey !== undefined) {
      item = this.getItemByGridIndexKey(gridIndexKey);
    }
    return item;
  }

  getItemByGridIndexKey(gridIndexKey) {
    let item;
    if (gridIndexKey !== undefined) {
      item = this.items[gridIndexKey];
    }
    return item;
  }

  getItemByGridIndexKey(gridIndexKey) {
    let item;
    if (gridIndexKey !== undefined) {
      item = this.items[gridIndexKey];
    }
    return item;
  }

  getItemGridIndexKeysByRange(startIndex, endIndex) {
    let itemGridIndexKeys;
    if (startIndex !== undefined && endIndex !== undefined) {
      itemGridIndexKeys = Object.keys(this.items).slice(startIndex, endIndex);
    }
    return itemGridIndexKeys;
  }

  getItemCount() {
    return Object.keys(this.items).length;
  }

  stackItem() {}

  identifyItemByGridIndex(gridIndex) {
    let isItemIdentified;
    const item = this.getItemByGridIndex(gridIndex);
    if (item !== undefined) {
      item.is_known = true;
      isItemIdentified = item.is_known;
    }
    return isItemIdentified;
  }

  rotateItemByGridIndex(gridIndex, newRotation) {
    let isItemRotated = false;
    const item = this.getItemByGridIndex(gridIndex);
    if (item !== undefined) {
      item.is_rotated = newRotation;
      isItemRotated = true;
    }
    return isItemRotated;
  }

  removeItemByGridIndex(gridIndex) {
    let isItemRemoved = false;
    const gridIndexKey = this.formatGridIndex(gridIndex);
    if (gridIndexKey !== undefined) {
      if (this.getItemByGridIndexKey(gridIndexKey) !== undefined) {
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
