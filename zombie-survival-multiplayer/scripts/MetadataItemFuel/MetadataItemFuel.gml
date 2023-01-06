function MetadataItemFuel(_fuel_value) : Metadata() constructor
{
	fuel_value = _fuel_value;
    fuel_left = fuel_value;
	
	static ToJSONStruct = function()
	{
		return {
			fuel_value: fuel_value,
			fuel_left: fuel_left
		}
	}
}