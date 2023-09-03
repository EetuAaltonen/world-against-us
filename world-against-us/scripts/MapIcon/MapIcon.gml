function MapIcon(_object_name, _position, _origin, _size, _icon_style = undefined, _icon_alpha = 1) constructor
{
	object_name = _object_name;
	position = _position;
	origin = _origin;
	size = _size;
	icon_style = _icon_style;
	icon_alpha = _icon_alpha;
	
	static ToJSONStruct = function()
	{
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var scaledOrigin = ScaleFloatValuesToIntVector2(origin.X, origin.Y);
		var formatPosition = (!is_undefined(scaledPosition)) ? scaledPosition.ToJSONStruct() : undefined;
		var formatOrigin = (!is_undefined(scaledOrigin)) ? scaledOrigin.ToJSONStruct() : undefined;
		var scaledSize = ScaleFloatValuesToIntSize(size.w, size.h);
		var formatSize = (!is_undefined(scaledSize)) ? scaledSize.ToJSONStruct() : undefined;
		
		return {
			object_name: object_name,
			position: formatPosition,
			origin: formatOrigin,
			size: formatSize,
			icon_alpha: icon_alpha
		}
	}
}