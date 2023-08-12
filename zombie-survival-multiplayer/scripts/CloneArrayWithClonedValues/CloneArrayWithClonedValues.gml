function CloneArrayWithClonedValues(_arrayToClone)
{
	var cloneArray = [];
	var arrayLength = array_length(_arrayToClone);
	
	for (var i = 0; i < arrayLength; i++)
	{
		var arrayEntity = _arrayToClone[@ i];
		if (!is_undefined(arrayEntity))
		{
			var staticFunctions = static_get(arrayEntity);
			if (!is_undefined(staticFunctions[$ "Clone"]))
			{
				array_push(cloneArray, arrayEntity.Clone());
			}
		}
	}
	
	return cloneArray;
}