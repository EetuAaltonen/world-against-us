import GridIndex from "../inventory/GridIndex.js";

export default function (jsonObject) {
  let parsedGridIndex;
  if (jsonObject !== undefined) {
    parsedGridIndex = new GridIndex(
      jsonObject["col"] ?? 0,
      jsonObject["row"] ?? 0
    );
  }
  return parsedGridIndex;
}
