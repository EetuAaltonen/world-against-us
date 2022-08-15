function GetContentValueByKey(_content, _key)
{
	var value = undefined;
	
	if (!is_undefined(_content))
	{
		var contentSize = array_length(_content);
		for (var i = 0; i < contentSize; i++)
		{
			var valueKeyPair = _content[@ i];
			if (valueKeyPair[$ "key"] == _key)
			{
				value = valueKeyPair[$ "value"];
				break;
			}
		}
	}
	
	return value;
}