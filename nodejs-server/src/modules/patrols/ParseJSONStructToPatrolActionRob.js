import PatrolActionRob from "./PatrolActionRob.js";

const UNDEFINED_UUID = "nuuuuuuu-uuuu-uuuu-uuuu-ullundefined";

export default function (jsonStruct) {
  let parsedPatrolActionRob;
  if (jsonStruct !== undefined) {
    parsedPatrolActionRob = new PatrolActionRob(
      jsonStruct["region_id"] ?? undefined,
      jsonStruct["patrol_id"] ?? undefined,
      jsonStruct["target_network_id"] ?? UNDEFINED_UUID,
      jsonStruct["target_player_tag"] ?? undefined
    );
  }
  return parsedPatrolActionRob;
}
