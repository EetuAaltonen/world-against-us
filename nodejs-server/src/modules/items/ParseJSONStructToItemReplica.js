import ItemReplica from "./ItemReplica.js";
import ParseJSONStructToGridIndex from "../inventory/ParseJSONStructToGridIndex.js";

export default function (jsonStruct) {
  let parsedItemReplica;
  if (jsonStruct !== undefined) {
    const parsedGridIndex = ParseJSONStructToGridIndex(
      jsonStruct["grid_index"] ?? undefined
    );

    parsedItemReplica = new ItemReplica(
      jsonStruct["name"] ?? "",
      jsonStruct["quantity"] ?? 1,
      jsonStruct["metadata"] ?? undefined,
      jsonStruct["is_rotated"] ?? false,
      jsonStruct["is_known"] ?? false,
      parsedGridIndex
    );
  }
  return parsedItemReplica;
}
