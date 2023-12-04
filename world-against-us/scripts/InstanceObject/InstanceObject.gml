function InstanceObject(_sprite_index, _object_index, _position) constructor
{
	spr_index = _sprite_index;
	obj_index = _object_index;
	obj_name = object_get_name(obj_index);
	position = _position;
	
	instance_ref = noone;
	
	static ToJSONStruct = function()
	{
		// OVERRIDE THIS FUNCTION
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var formatPosition = (!is_undefined(scaledPosition)) ? scaledPosition.ToJSONStruct() : undefined;
		return {
			spr_index: spr_index,
			obj_index: obj_index,
			obj_name: obj_name,
			position: formatPosition
		}
	}
}