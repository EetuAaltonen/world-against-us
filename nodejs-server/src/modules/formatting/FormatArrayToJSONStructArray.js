export default function (array) {
  let formatStructArray = [];
  if (array !== undefined) {
    formatStructArray = array.map((value) => {
      return value.toJSONStruct();
    });
  }
  return formatStructArray;
}
