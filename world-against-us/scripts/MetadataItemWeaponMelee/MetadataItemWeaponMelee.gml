function MetadataItemWeaponMelee(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position, _base_damage) : MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position) constructor
{
    base_damage = _base_damage;
	
	static ToJSONStruct = function()
	{
		return {
			// TODO: Fix ToJSONStruct
		}
	}
}