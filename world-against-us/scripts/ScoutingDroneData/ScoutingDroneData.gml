function ScoutingDroneData(_region_id, _position) constructor
{
	region_id = _region_id;
	position = _position;
	
	static ToJSONStruct = function()
	{
		var formatScaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		return {
			region_id: region_id,
			position: formatScaledPosition,
		}
	}
	
	static OnDestroy = function(_struct = self)
	{
		DeleteStruct(_struct.position);
	}
}