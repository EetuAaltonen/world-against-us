function MetadataItemWeaponMelee(_fire_rate, _range, _kickback, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position, _damage) : MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _barrel_pos, _right_hand_position, _left_hand_position) constructor
{
    damage = _damage;
	
	static ToJSONStruct = function()
	{
		return {
			// TODO: Fix ToJSONStruct
		}
	}
}