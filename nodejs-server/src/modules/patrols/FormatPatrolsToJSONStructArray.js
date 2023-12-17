export default function (patrols) {
  let formatPatrolArray = [];
  if (patrols !== undefined) {
    Object.keys(patrols).forEach((patrolId) => {
      const patrol = patrols[patrolId];
      formatPatrolArray.push(patrol.toJSONStruct());
    });
  }
  return formatPatrolArray;
}
