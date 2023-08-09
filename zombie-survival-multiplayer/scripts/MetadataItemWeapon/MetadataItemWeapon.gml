function MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position) : Metadata() constructor
{
    fire_rate = _fire_rate;
    range = _range;
    kickback = _kickback;
	weapon_offset = new Vector2(_weapon_offset.X, _weapon_offset.Y);
	chamber_pos = new Vector2(_chamber_pos.X, _chamber_pos.Y);
	barrel_pos = new Vector2(_barrel_pos.X, _barrel_pos.Y);
	right_hand_position = new Vector2(_right_hand_position.X, _right_hand_position.Y);
	left_hand_position = new Vector2(_left_hand_position.X, _left_hand_position.Y);
	// TODO: isHolstered variable
	
	static ToJSONStruct = function()
	{
		// TODO: Fix ToJSONStruct function in subweapon metadata
		var formatWeaponOffset = weapon_offset.ToJSONStruct();
		var formatChamberPos = chamber_pos.ToJSONStruct();
		var formatBarrelPos = barrel_pos.ToJSONStruct();
		var formatRightHandPos = right_hand_position.ToJSONStruct();
		var formatLeftHandPos = left_hand_position.ToJSONStruct();
		return {
			fire_rate: fire_rate,
			range: range,
			weapon_offset: formatWeaponOffset,
			chamber_pos: formatChamberPos,
			barrel_pos: formatBarrelPos,
			right_hand_position: formatRightHandPos,
			left_hand_position: formatLeftHandPos
		}
	}
}