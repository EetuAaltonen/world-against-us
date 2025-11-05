function MetadataItemWeaponGun(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _firing_modes, _recoil, _attachment_slots) : MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position) constructor
{
	chamber_type = _chamber_type;
	caliber = _caliber;
	firing_modes = _firing_modes;
	recoil = _recoil;
	attachment_slots = _attachment_slots;
	
	magazine = undefined;
	
	// FIRING MODE
	firing_mode_index = 0;
	burst_firing_index = 0;
	
	static ToJSONStruct = function()
	{
		var formatMagazine = (!is_undefined(magazine)) ? magazine.ToJSONStruct() : magazine;
		return {
			magazine: formatMagazine
		}
	}
	
	static Clone = function()
	{
		var clone = new MetadataItemWeaponGun(
			fire_rate,
			range,
			kickback,
			weapon_offset,
			chamber_pos,
			barrel_pos,
			right_hand_position,
			left_hand_position,
			chamber_type,
			caliber,
			firing_modes,
			recoil,
			attachment_slots
		);
		clone.magazine = (!is_undefined(magazine)) ? magazine.Clone() : undefined;
		return clone;
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.magazine);
		_struct.magazine = undefined;
	}
	
	static GetAmmoCount = function()
	{
		var bulletCount = 0;
		if (!is_undefined(magazine))
		{
			bulletCount = magazine.metadata.GetBulletCount();
		}
		return bulletCount;
	}
	
	static GetAmmoCapacity = function()
	{
		var ammoCapacity = 0;
		if (!is_undefined(magazine))
		{
			ammoCapacity = magazine.metadata.GetBulletCapacity();
		}
		return ammoCapacity;
	}
}