function MetadataItemWeapon(_caliber, _fire_rate, _range, _recoil, _attachment_slots, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position) : Metadata() constructor
{
    caliber = _caliber;
    fire_rate = _fire_rate;
    range = _range;
    recoil = _recoil;
    attachment_slots = _attachment_slots;
	weapon_offset = new Vector2(_weapon_offset.X, _weapon_offset.Y);
	barrel_pos = new Vector2(_barrel_pos.X, _barrel_pos.Y);
	right_hand_position = new Vector2(_right_hand_position.X, _right_hand_position.Y);
	left_hand_position = new Vector2(_left_hand_position.X, _left_hand_position.Y);
	magazine = undefined;
	// TODO: isHolstered variable
	
	static ToJSONStruct = function()
	{
		var formatBarrelPos = barrel_pos.ToJSONStruct();
		var formatRightHandPos = right_hand_position.ToJSONStruct();
		var formatLeftHandPos = left_hand_position.ToJSONStruct();
		var formatMagazine = !is_undefined(magazine) ? magazine.ToJSONStruct() : magazine;
		return {
			caliber: caliber,
			fire_rate: fire_rate,
			range: range,
			recoil: recoil,
			attachment_slots: attachment_slots,
			barrel_pos: formatBarrelPos,
			right_hand_position: formatRightHandPos,
			left_hand_position: formatLeftHandPos,
			magazine: formatMagazine,
		}
	}
}