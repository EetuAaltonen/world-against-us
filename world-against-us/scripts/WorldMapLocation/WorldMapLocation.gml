function WorldMapLocation(_room_ref, _room_index, _name, _size, _patrol_path) constructor
{
	room_ref = _room_ref;
	room_index = _room_index;
	name = _name;
	size = _size;
	patrol_path = _patrol_path;
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.size);
		_struct.size = undefined;
	}
}