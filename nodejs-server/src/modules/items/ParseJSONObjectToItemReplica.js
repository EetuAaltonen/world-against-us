import ItemReplica from "./ItemReplica.js";
import GridIndex from "../inventory/GridIndex.js";

export default function (jsonStruct) {
  if (jsonStruct !== undefined) {
    const parsedGridIndex = new GridIndex(
      jsonStruct.grid_index.col ?? 0,
      jsonStruct.grid_index.row ?? 0
    );
    return new ItemReplica(
      jsonStruct.name ?? "",
      jsonStruct.quantity ?? 1,
      jsonStruct.metadata ?? undefined,
      jsonStruct.is_rotated ?? false,
      jsonStruct.is_known ?? false,
      parsedGridIndex
    );
  }
}
