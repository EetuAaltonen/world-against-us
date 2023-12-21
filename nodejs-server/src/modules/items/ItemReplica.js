import GridIndex from "../inventory/GridIndex.js";

export default class ItemReplica {
  constructor(name, quantity, metadata, isRotated, isKnown, gridIndex) {
    this.name = name;
    this.quantity = quantity ?? 1;
    this.metadata = metadata ?? undefined;
    this.isRotated = isRotated ?? false;
    this.isKnown = isKnown ?? false;
    this.gridIndex = new GridIndex(gridIndex.col ?? 0, gridIndex.row ?? 0);
  }

  toJSONStruct() {
    const formatGridIndex = this.gridIndex.toJSONStruct(this.gridIndex);
    return {
      name: this.name,
      quantity: this.quantity,
      metadata: this.metadata,
      is_rotated: this.isRotated,
      is_known: this.isKnown,
      grid_index: formatGridIndex,
    };
  }
}
