function ScaleIntValuesToFloatVector2(_value1, _value2)
{
	var multiplier = 0.01;
	return new Vector2(_value1 * multiplier, _value2 * multiplier);
}