import GridIndex from "./GridIndex.js";

export default function (jsonStruct) {
  let parsedGridIndex;
  if (jsonStruct !== undefined) {
    parsedGridIndex = new GridIndex(
      jsonStruct["col"] ?? 0,
      jsonStruct["row"] ?? 0
    );
  }
  return parsedGridIndex;
}
