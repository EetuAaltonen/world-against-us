/// @function			ScaleFloatValueToInt(_value)
/// @description		Converts a provided float to int
/// @param	{number} value  Number to convert
/// @return {number}
function ScaleFloatValueToInt(_value)
{
	return round(_value * FIXED_POINT_PRECISION);
}