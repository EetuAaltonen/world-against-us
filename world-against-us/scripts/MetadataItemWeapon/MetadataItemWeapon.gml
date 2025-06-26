function MetadataItemWeapon(_fire_rate, _range, _kickback, _weapon_offset, _chamber_pos, _barrel_pos, _right_hand_position, _left_hand_position) : Metadata() constructor
{
	fire_rate = _fire_rate;
	range = _range;
	kickback = _kickback;
	weapon_offset = new Vector2(_weapon_offset.X, _weapon_offset.Y);
	chamber_pos = new Vector2(_chamber_pos.X, _chamber_pos.Y);
	barrel_pos = new Vector2(_barrel_pos.X, _barrel_pos.Y);
	// TODO: Remove obsolete properties
	right_hand_position = new Vector2(_right_hand_position.X, _right_hand_position.Y);
	left_hand_position = new Vector2(_left_hand_position.X, _left_hand_position.Y);
	
	static ToJSONStruct = function()
	{
		// NO DYNAMIC METADATA
		return EMPTY_STRUCT;
	}
	
	static Clone = function()
	{
		// OVERRIDE THIS FUNCTION
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.weapon_offset);
		_struct.weapon_offset = undefined;
		ReleaseVariableFromMemory(_struct.chamber_pos);
		_struct.chamber_pos = undefined;
		ReleaseVariableFromMemory(_struct.barrel_pos);
		_struct.barrel_pos = undefined;
	}
}