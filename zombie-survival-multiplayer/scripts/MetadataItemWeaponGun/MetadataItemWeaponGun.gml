function MetadataItemWeaponGun(_fire_rate, _range, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position, _chamber_type, _caliber, _recoil, _attachment_slots) : MetadataItemWeapon(_fire_rate, _range, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position) constructor
{
    chamber_type = _chamber_type;
    caliber = _caliber;
    recoil = _recoil;
    attachment_slots = _attachment_slots;
	magazine = undefined;
	
	static ToJSONStruct = function()
	{
		return {
			// TODO: Fix ToJSONStruct
		}
	}
}