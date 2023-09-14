function ScaleIntValuesToFloatSize(_value1, _value2)
{
	return new Size(_value1 / FIXED_POINT_PRECISION, _value2 / FIXED_POINT_PRECISION);
}