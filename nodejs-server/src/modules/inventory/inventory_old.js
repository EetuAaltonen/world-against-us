const InventorySize = require("./inventorySize");
const GridIndex = require("./gridIndex");
const Size = require("../math/size");

class Inventory {
  constructor(inventoryId, type = "temp", size = new InventorySize(10, 10)) {
    this.items = [];
    this.inventoryId = inventoryId;
    this.type = type;
    this.size = size;

    this.gridData = [];
    // Init grid data
    for (var i = 0; i < this.size.rows; i++) {
      var rowData = [];
      for (var j = 0; j < this.size.columns; j++) {
        rowData.push(undefined);
      }
      this.gridData.push(rowData);
    }
  }

  Add(item, gridIndex = undefined, known = true) {
    if (gridIndex != undefined) {
      if (this.IsGridAreaEmpty(gridIndex.col, gridIndex.row, item)) {
        item.grid_index = gridIndex;
      } else {
        item.grid_index = this.FindEmptyIndex(item);
      }
    } else {
      item.grid_index = this.FindEmptyIndex(item);
    }

    item.known = known;

    if (item.grid_index != undefined) {
      item.sourceInventory = this;
      this.FillGridArea(
        item.grid_index.col,
        item.grid_index.row,
        item.size,
        item.grid_index
      );
      this.items.push(item);
    } else {
      // MESSAGE LOG
      console.log("Item: '" + item.name + "' doesn't fit!");
    }
  }

  GetByIndex(gridIndex) {
    return this.items.find(
      (item) =>
        item.grid_index.col == gridIndex.col &&
        item.grid_index.row == gridIndex.row
    );
  }

  GetAll() {
    return this.items;
  }

  IdentifyByIndex(gridIndex) {
    var item = this.GetByIndex(gridIndex);
    if (item != undefined) {
      item.known = true;
    }
  }

  MoveAndRotateByIndex(gridIndex, newGridIndex, isRotated) {
    var item = this.GetByIndex(gridIndex);
    const originalRotation = item.isRotated;
    if (item != undefined) {
      // Clear previous spot
      this.FillGridArea(gridIndex.col, gridIndex.row, item.size, undefined);

      if (item.isRotated != isRotated) {
        this.RotateItem(item);
      }

      if (
        this.IsGridAreaEmpty(
          item.grid_index.col,
          item.grid_index.row,
          item,
          item.sourceInventory,
          item.grid_index
        )
      ) {
        item.grid_index = newGridIndex;
      } else {
        // Reverse rotation if item doesn't fit
        if (item.isRotated != originalRotation) {
          this.RotateItem(item);
        }
      }

      // Set new spot
      this.FillGridArea(
        item.grid_index.col,
        item.grid_index.row,
        item.size,
        item.grid_index
      );
    }
  }

  MoveByIndex(gridIndex, newGridIndex) {
    var item = this.GetByIndex(gridIndex);
    if (item != undefined) {
      // Clear previous spot
      this.FillGridArea(gridIndex.col, gridIndex.row, item.size, undefined);

      // Set new spot
      item.grid_index = newGridIndex;
      this.FillGridArea(
        item.grid_index.col,
        item.grid_index.row,
        item.size,
        item.grid_index
      );
    }
  }

  RotateByIndex(gridIndex, isRotated) {
    var item = this.GetByIndex(gridIndex);
    if (item != undefined) {
      if (item.isRotated != isRotated) {
        // Clear old fill area
        this.FillGridArea(
          item.grid_index.col,
          item.grid_index.row,
          item.size,
          undefined
        );

        this.RotateItem(item);

        // Fill new area
        this.FillGridArea(
          item.grid_index.col,
          item.grid_index.row,
          item.size,
          item.grid_index
        );
      }
    }
  }

  DeleteByIndex(gridIndex) {
    var item = this.GetByIndex(gridIndex);

    if (item != undefined) {
      this.FillGridArea(gridIndex.col, gridIndex.row, item.size, undefined);

      this.items = this.items.filter(
        (item) =>
          item.grid_index.col != gridIndex.col ||
          item.grid_index.row != gridIndex.row
      );
    }
  }

  FindEmptyIndex(item) {
    var index = undefined;
    for (var i = 0; i < this.size.rows; i++) {
      if (index != undefined) break;
      for (var j = 0; j < this.size.columns; j++) {
        if (index != undefined) break;
        if (this.gridData[i][j] == undefined) {
          if (this.IsGridAreaEmpty(j, i, item)) {
            index = new GridIndex(j, i);
          } else {
            // CHECK ROTATED VERSION
            //item.Rotate();
            this.RotateItem(item);
            if (this.IsGridAreaEmpty(j, i, item)) {
              index = new GridIndex(j, i);
            } else {
              // REVERSE ROTATION IF DIDN'T FIT
              //item.Rotate();
              this.RotateItem(item);
            }
          }
        }
      }
    }
    return index;
  }

  IsGridAreaEmpty(
    col,
    row,
    item,
    ignoreSource = undefined,
    ignoreGridIndex = undefined
  ) {
    var isEmpty = true;
    const arrayDimension = [this.gridData.length, this.gridData[0].length];
    if (
      col + item.size.w - 1 < arrayDimension[1] &&
      row + item.size.h - 1 < arrayDimension[0]
    ) {
      for (var i = row; i < row + item.size.h; i++) {
        if (!isEmpty) break;
        for (var j = col; j < col + item.size.w; j++) {
          if (!isEmpty) break;
          var gridIndex = this.gridData[i][j];
          if (gridIndex != undefined) {
            if (ignoreGridIndex != undefined) {
              isEmpty =
                item.sourceInventory.inventoryId == ignoreSource.inventoryId &&
                gridIndex.col == ignoreGridIndex.col &&
                gridIndex.row == ignoreGridIndex.row;
            } else {
              isEmpty = false;
            }
          }
        }
      }
    } else {
      isEmpty = false;
    }
    return isEmpty;
  }

  FillGridArea(col, row, itemSize, value) {
    for (var i = row; i < row + itemSize.h; i++) {
      for (var j = col; j < col + itemSize.w; j++) {
        this.gridData[i][j] = value;
      }
    }
  }

  // TODO: Move this into Item class
  RotateItem(item) {
    if (item.size.w != item.size.h) {
      item.isRotated = !item.isRotated;
      // Swap width and height
      item.size = new Size(item.size.h, item.size.w);
    }
  }
}

module.exports = Inventory;
