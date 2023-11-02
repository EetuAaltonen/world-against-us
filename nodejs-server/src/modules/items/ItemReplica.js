import GridIndex from "../inventory/GridIndex.js";

export default class ItemReplica {
  constructor(name, quantity, metadata, is_rotated, is_known, grid_index) {
    this.name = name;
    this.quantity = quantity ?? 1;
    this.metadata = metadata ?? undefined;
    this.is_rotated = is_rotated ?? false;
    this.is_known = is_known ?? false;
    this.grid_index = new GridIndex(grid_index.col ?? 0, grid_index.row ?? 0);
  }
}
