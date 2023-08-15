function MetadataItemWeaponGun(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) : MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position) constructor
{
    chamber_type = _chamber_type;
    caliber = _caliber;
    recoil = _recoil;
    attachment_slots = _attachment_slots;
	magazine = undefined;
	
	static ToJSONStruct = function()
	{
		var formatMagazine = (!is_undefined(magazine)) ? magazine.ToJSONStruct() : magazine;
		return {
			magazine: formatMagazine
		}
	}
	
	static GetAmmoCount = function()
	{
		var bulletCount = 0;
		if (!is_undefined(magazine))
		{
			bulletCount = magazine.metadata.GetAmmoCount();
		}
		return bulletCount;
	}
	
	static GetAmmoCapacity = function()
	{
		var ammoCapacity = 0;
		if (!is_undefined(magazine))
		{
			ammoCapacity = magazine.metadata.GetAmmoCapacity();
		}
		return ammoCapacity;
	}
}