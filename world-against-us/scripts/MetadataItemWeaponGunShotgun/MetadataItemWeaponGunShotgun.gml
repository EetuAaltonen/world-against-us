function MetadataItemWeaponGunShotgun(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots, _shell_capacity) : MetadataItemWeaponGun(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) constructor
{
    shell_capacity = _shell_capacity;
	shells = [];
	
	static ToJSONStruct = function()
	{
		// TODO: Fix ToJSONStruct
		var shellArray = [];
		var shellCount = GetAmmoCount();
		for (var i = 0; i < shellCount; i++)
		{
			var shell = shells[@ i];
			array_push(shellArray, shell.ToJSONStruct());
		}
		
		return {
			shells: shellArray
		}
	}
	
	static GetAmmoCount = function()
	{
		return array_length(shells);
	}
	
	static GetAmmoCapacity = function()
	{
		return shell_capacity;
	}
	
	static ReloadAmmo = function(_ammo)
	{
		_ammo.sourceInventory = undefined;
		return array_push(shells, _ammo);
	}
	
	static UnloadAmmo = function()
	{
		return array_pop(shells);
	}
}