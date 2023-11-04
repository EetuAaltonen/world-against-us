import ItemReplica from "./ItemReplica.js";
import ParseJSONObjectToGridIndex from "../inventory/ParseJSONObjectToGridIndex.js";

export default function (jsonObject) {
  let parsedItem;
  if (jsonObject !== undefined) {
    const parsedGridIndex = ParseJSONObjectToGridIndex(
      jsonObject["grid_index"]
    );

    parsedItem = new ItemReplica(
      jsonObject["name"] ?? "",
      jsonObject["quantity"] ?? 1,
      jsonObject["metadata"] ?? undefined,
      jsonObject["is_rotated"] ?? false,
      jsonObject["is_known"] ?? false,
      parsedGridIndex
    );
  }
  return parsedItem;
}
