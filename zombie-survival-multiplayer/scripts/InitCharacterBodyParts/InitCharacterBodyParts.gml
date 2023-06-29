function InitCharacterBodyParts(_race)
{
	var bodyParts = undefined;
	switch (_race)
	{
		case CHARACTER_RACE.humanoid:
		{
			bodyParts = ds_map_create();
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Head, new CharacterBodyPart("Head", 10));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Chest, new CharacterBodyPart("Chest", 20));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightArm, new CharacterBodyPart("Right Arm", 10));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftArm, new CharacterBodyPart("Left Arm", 10));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Stomach, new CharacterBodyPart("Stomach", 10));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightLeg, new CharacterBodyPart("Right Leg", 15));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftLeg, new CharacterBodyPart("Left Leg", 15));
		} break;
		default:
		{
			show_debug_message(string("Trying to init character body parts with unmapped race {0}!", _race));
		}
	}
	
	return bodyParts;
}