function ScaleFloatValuesToIntVector2(_value1, _value2)
{
	var multiplier = 100;
	return new Vector2(round(_value1 * multiplier), round(_value2 * multiplier));
}
