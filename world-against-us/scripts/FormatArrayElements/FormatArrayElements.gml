function FormatArrayElements(_arrayRef, _formatFunc)
{
	if (is_array(_arrayRef))
	{
		var elemCount = array_length(_arrayRef);
		for (var i = 0; i < elemCount; i++)
		{
			var elem = _arrayRef[@ i];
			if (!is_undefined(elem))
			{
				_arrayRef[@ i] = _formatFunc(elem);
			}
		}
	}
}