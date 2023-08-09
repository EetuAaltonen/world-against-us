function MetadataItemWeaponGunFlamethrower(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) : MetadataItemWeaponGun(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) constructor
{
	fuel_tank = undefined;
	
	static ToJSONStruct = function()
	{
		// TODO: Fix ToJSONStruct
		return {
			fuel_tank: fuel_tank
		}
	}
	
	static GetAmmoCount = function()
	{
		var fuelLevel = 0;
		if (!is_undefined(fuel_tank))
		{
			fuelLevel = fuel_tank.metadata.fuel_level;
		}
		return fuelLevel;
	}
	
	static GetAmmoCapacity = function()
	{
		var fuelCapacity = 0;
		if (!is_undefined(fuel_tank))
		{
			fuelCapacity = fuel_tank.metadata.GetAmmoCapacity();
		}
		return fuelCapacity;
	}
}