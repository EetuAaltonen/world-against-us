function GameSaveDataLastLocation(_position, _room_index) constructor
{
	position = _position;
	room_index = _room_index;
	
	static ToJSONStruct = function()
	{
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var formatPosition = scaledPosition.ToJSONStruct();
		return {
			position: formatPosition,
			room_index: room_index
		}
	}
	
	static OnDestroy = function()
	{
		// NO PROPERTIES TO DESTROY
		return;	
	}
}