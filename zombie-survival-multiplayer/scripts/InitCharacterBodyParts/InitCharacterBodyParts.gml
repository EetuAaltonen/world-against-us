function InitCharacterBodyParts(_race)
{
	var bodyParts = undefined;
	switch (_race)
	{
		case CHARACTER_RACE.humanoid:
		{
			bodyParts = ds_map_create();
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Head, new CharacterBodyPart(
				"Head", CHARACTER_BODY_PARTS.Head, 30,
				new Vector2Rectangle(new Vector2(0.25, 0), new Vector2(0.75, 0), new Vector2(0.75, 0.125), new Vector2(0.25, 0.125))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightArm, new CharacterBodyPart(
				"Right Arm", CHARACTER_BODY_PARTS.RightArm, 25,
				new Vector2Rectangle(new Vector2(0, 0.125), new Vector2(0.25, 0.125), new Vector2(0.25, 0.6), new Vector2(0, 0.6))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Chest, new CharacterBodyPart(
				"Chest", CHARACTER_BODY_PARTS.Chest, 50,
				new Vector2Rectangle(new Vector2(0.25, 0.125), new Vector2(0.75, 0.125), new Vector2(0.75, 0.35), new Vector2(0.25, 0.35))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftArm, new CharacterBodyPart(
				"Left Arm", CHARACTER_BODY_PARTS.LeftArm, 25,
				new Vector2Rectangle(new Vector2(0.75, 0.125), new Vector2(1, 0.125), new Vector2(1, 0.6), new Vector2(0.75, 0.6))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.Stomach, new CharacterBodyPart(
				"Stomach", CHARACTER_BODY_PARTS.Stomach, 40,
				new Vector2Rectangle(new Vector2(0.25, 0.35), new Vector2(0.75, 0.35), new Vector2(0.75, 0.5), new Vector2(0.25, 0.5))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.RightLeg, new CharacterBodyPart(
				"Right Leg", CHARACTER_BODY_PARTS.RightLeg, 30,
				new Vector2Rectangle(new Vector2(0.25, 0.5), new Vector2(0.5, 0.5), new Vector2(0.5, 1), new Vector2(0.25, 1))
			));
			ds_map_add(bodyParts, CHARACTER_BODY_PARTS.LeftLeg, new CharacterBodyPart(
				"Left Leg", CHARACTER_BODY_PARTS.LeftLeg, 30,
				new Vector2Rectangle(new Vector2(0.5, 0.5), new Vector2(0.75, 0.5), new Vector2(0.75, 1), new Vector2(0.5, 1))
			));
		} break;
		default:
		{
			show_debug_message(string("Trying to init character body parts with unmapped race {0}!", _race));
		}
	}
	
	return bodyParts;
}