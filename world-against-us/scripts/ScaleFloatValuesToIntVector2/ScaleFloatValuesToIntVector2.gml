function ScaleFloatValuesToIntVector2(_value1, _value2)
{
	return new Vector2(round(_value1 * FIXED_POINT_PRECISION), round(_value2 * FIXED_POINT_PRECISION));
}
