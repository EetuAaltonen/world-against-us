export default function (hashMap) {
  let formatStructArray = [];
  if (hashMap !== undefined) {
    Object.keys(hashMap).forEach((key) => {
      const value = hashMap[key];
      formatStructArray.push(value.toJSONStruct());
    });
  }
  return formatStructArray;
}
