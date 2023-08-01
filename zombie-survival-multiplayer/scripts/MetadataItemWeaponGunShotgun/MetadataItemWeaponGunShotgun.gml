function MetadataItemWeaponGunShotgun(_fire_rate, _range, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots, _shell_capacity) : MetadataItemWeaponGun(_fire_rate, _range, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) constructor
{
    shell_capacity = _shell_capacity;
	shells = [];
	
	static ToJSONStruct = function()
	{
		// TODO: Fix ToJSONStruct
		var shellArray = [];
		var shellCount = GetShellCount();
		for (var i = 0; i < shellCount; i++)
		{
			var shell = shells[@ i];
			array_push(shellArray, shell.ToJSONStruct());
		}
		
		return {
			caliber: caliber,
			capacity: capacity,
			shells: shells
		}
	}
	
	static GetShellCount = function()
	{
		return array_length(shells);
	}
	
	static LoadShell = function(_shell)
	{
		return array_push(shells, _shell);
	}
	
	static UnloadShell = function()
	{
		return array_pop(shells);
	}
}