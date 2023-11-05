export default function (jsonObjects, parseFunction) {
  let parsedObjects = [];
  if (jsonObjects !== undefined) {
    if (Array.isArray(jsonObjects)) {
      if (parseFunction !== undefined) {
        jsonObjects.forEach((jsonObject) => {
          parsedObjects.push(parseFunction(jsonObject));
        });
      }
    }
  }
  return parsedObjects;
}
