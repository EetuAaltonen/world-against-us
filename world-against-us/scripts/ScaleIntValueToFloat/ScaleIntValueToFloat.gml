/// @function		ScaleIntValueToFloat(_value)
/// @description    Converts a provided int value to float
/// @param	{number} value  Number to convert
/// @return {number}
function ScaleIntValueToFloat(_value)
{
	return _value / FIXED_POINT_PRECISION;
}