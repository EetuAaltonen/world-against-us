export default function (items) {
  let formatItemArray = [];
  if (items !== undefined) {
    Object.keys(items).forEach((gridIndex) => {
      const item = items[gridIndex];
      formatItemArray.push(item);
    });
  }
  return formatItemArray;
}
