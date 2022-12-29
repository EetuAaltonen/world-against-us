function ArrayContainsValue(_array, _value)
{
	var arrayContainsValue = false;
	var arrayLegth = array_length(_array);
	for (var i = 0; i < arrayLegth; i++)
	{
		if (_array[@ i] == _value)
		{
			arrayContainsValue = true;
			break;
		}
	}
	return arrayContainsValue;
}