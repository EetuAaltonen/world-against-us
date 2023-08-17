function GetContentValueByKey(_content, _key)
{
	var value = undefined;
	
	if (!is_undefined(_content))
	{
		var contentSize = array_length(_content);
		for (var i = 0; i < contentSize; i++)
		{
			var keyValuePair = _content[@ i];
			if (keyValuePair[$ "key"] == _key)
			{
				value = keyValuePair[$ "value"];
				break;
			}
		}
	}
	
	return value;
}