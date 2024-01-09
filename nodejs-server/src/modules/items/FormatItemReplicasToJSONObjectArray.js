export default function (items) {
  let formatItemArray = [];
  if (items !== undefined) {
    Object.keys(items).forEach((gridIndex) => {
      const item = items[gridIndex];
      const formatItem = item.toJSONStruct();
      formatItemArray.push(formatItem);
    });
  }
  return formatItemArray;
}
