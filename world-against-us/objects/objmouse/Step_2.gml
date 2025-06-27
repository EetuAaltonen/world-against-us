if (instance_exists(global.InstancePlayer))
{
	var characterRef = global.InstancePlayer.character;
	var primaryWeaponRef = characterRef.gear.GetItemBySlot(characterRef.gear.primary_weapon);
	if (!is_undefined(primaryWeaponRef))
	{
		aimPos.X = mouse_x + abs(characterRef.gear.primary_weapon_data.barrel_to_ground_offset.X);
		aimPos.Y = mouse_y + abs(characterRef.gear.primary_weapon_data.barrel_to_ground_offset.Y);
	}
}