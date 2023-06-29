function RGBAColor(_red, _green, _blue, _alpha) constructor
{
	red = _red;
	green = _green;
	blue = _blue;
	alpha = _alpha;
	
	static ToJSONStruct = function()
	{
		return {
			red: red,
			green: green,
			blue: blue,
			alpha: alpha
		}
	}
	
	static Clone = function()
	{
		return new RGBAColor(
			red,
			green,
			blue,
			alpha
		);
	}
	
	static MakeColor = function()
	{
		return make_color_rgb(red, green, blue);
	}
}