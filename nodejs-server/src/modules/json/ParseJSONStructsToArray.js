export default function (jsonStructArray, parseFunction) {
  let parsedObjectArray = [];
  if (jsonStructArray !== undefined) {
    if (Array.isArray(jsonStructArray)) {
      if (parseFunction !== undefined) {
        jsonStructArray.forEach((jsonStruct) => {
          parsedObjectArray.push(parseFunction(jsonStruct));
        });
      }
    }
  }
  return parsedObjectArray;
}
