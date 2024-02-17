import ConsoleHandler from "../console/ConsoleHandler.js";

import FormatItemReplicasToJSONObjectArray from "../items/FormatItemReplicasToJSONObjectArray.js";

export default class Inventory {
  constructor(inventoryId) {
    this.inventoryId = inventoryId;
    this.items = {};
  }

  toJSONStruct() {
    const formatItems = FormatItemReplicasToJSONObjectArray(this.items);
    return {
      inventory_id: this.inventoryId,
      items: formatItems,
    };
  }

  addItem(item) {
    let isItemAdded = false;
    if (item !== undefined) {
      const existentItem = this.getItemByGridIndex(item.gridIndex);
      if (existentItem === undefined) {
        const gridIndexKey = this.formatGridIndex(item.gridIndex);
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
              ConsoleHandler.Log(
                `Unable to add item ${item.name} to inventory`
              );
            }
          }
        });
      } else {
        isItemsAdded = false;
      }
    }
    return isItemsAdded;
  }

  stackItem(item) {
    let isItemStacked = false;
    if (item !== undefined) {
      const existentItem = this.getItemByGridIndex(item.gridIndex);
      if (existentItem !== undefined) {
        if (item.quantity > 0) {
          existentItem.quantity += item.quantity;
          isItemStacked = true;
        }
      }
    }
    return isItemStacked;
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

  identifyItemByGridIndex(gridIndex) {
    let isItemIdentified;
    const item = this.getItemByGridIndex(gridIndex);
    if (item !== undefined) {
      item.isKnown = true;
      isItemIdentified = item.isKnown;
    }
    return isItemIdentified;
  }

  rotateItemByGridIndex(gridIndex, newRotation) {
    let isItemRotated = false;
    const item = this.getItemByGridIndex(gridIndex);
    if (item !== undefined) {
      item.isRotated = newRotation;
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
