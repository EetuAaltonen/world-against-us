import ContainerInventoryActionInfo from "./ContainerInventoryActionInfo.js";
import ParseJSONObjectToGridIndex from "../inventory/ParseJSONObjectToGridIndex.js";
import ParseJSONObjectToItemReplica from "../items/ParseJSONObjectToItemReplica.js";

export default function (jsonObject) {
  let parsedActionInfo;
  if (jsonObject !== undefined) {
    const parsedSourceGridIndex = ParseJSONObjectToGridIndex(
      jsonObject["source_grid_index"] ?? undefined
    );
    const parsedTargetGridIndex = ParseJSONObjectToGridIndex(
      jsonObject["target_grid_index"] ?? undefined
    );
    const parsedItem = ParseJSONObjectToItemReplica(
      jsonObject["item"] ?? undefined
    );

    parsedActionInfo = new ContainerInventoryActionInfo(
      jsonObject["container_id"] ?? undefined,
      parsedSourceGridIndex,
      parsedTargetGridIndex,
      jsonObject["is_rotated"] ?? false,
      jsonObject["is_known"] ?? false,
      parsedItem
    );
  }
  return parsedActionInfo;
}
