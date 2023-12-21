import InventoryStreamItems from "./InventoryStreamItems.js";

import ParseJSONStructsToArray from "../json/ParseJSONStructsToArray.js";
import ParseJSONStructToItemReplica from "../items/ParseJSONStructToItemReplica.js";

export default function (jsonStruct) {
  let parsedInventoryStreamItems;
  if (jsonStruct !== undefined) {
    const itemStructArray = jsonStruct["items"] ?? [];
    const parsedItems = ParseJSONStructsToArray(
      itemStructArray,
      ParseJSONStructToItemReplica
    );

    parsedInventoryStreamItems = new InventoryStreamItems(
      jsonStruct["region_id"] ?? undefined,
      jsonStruct["inventory_id"] ?? undefined,
      parsedItems
    );
  }
  return parsedInventoryStreamItems;
}
