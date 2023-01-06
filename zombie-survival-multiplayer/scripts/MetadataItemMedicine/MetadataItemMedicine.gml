function MetadataItemMedicine(_healing_value) : Metadata() constructor
{
	healing_value = _healing_value;
    healing_left = healing_value;
	
	static ToJSONStruct = function()
	{
		return {
			healing_value: healing_value,
			healing_left: healing_left
		}
	}
}