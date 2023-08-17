function CloneArrayMaterialsWithClonedValues(_materialArrayToClone)
{
	var cloneMaterialArray = [];
	var arrayLength = array_length(_materialArrayToClone);
	
	for (var i = 0; i < arrayLength; i++)
	{
		var material = _materialArrayToClone[@ i];
		if (!is_undefined(material))
		{
			var staticFunctions = static_get(material);
			if (!is_undefined(staticFunctions[$ "Clone"] ?? undefined))
			{
				array_push(cloneMaterialArray, material.Clone());
			}
		}
	}
	
	return cloneMaterialArray;
}