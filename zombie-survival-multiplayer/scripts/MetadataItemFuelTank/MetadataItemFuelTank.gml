function MetadataItemFuelTank(_caliber, _capacity) : Metadata() constructor
{
	caliber = _caliber;
    capacity = _capacity;
	fuel_level = capacity;
	
	static ToJSONStruct = function()
	{
		return {
			caliber: caliber,
			capacity: capacity,
			fuel_level: fuel_level
		}
	}
}