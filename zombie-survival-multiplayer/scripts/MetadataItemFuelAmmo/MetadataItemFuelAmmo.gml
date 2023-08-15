function MetadataItemFuelAmmo(_caliber, _capacity) : Metadata() constructor
{
	caliber = _caliber;
    capacity = _capacity;
	fuel_level = capacity;
	
	static ToJSONStruct = function()
	{
		return {
			fuel_level: fuel_level
		}
	}
	
	static GetAmmoCount = function()
	{
		return fuel_level;
	}
	
	static GetAmmoCapacity = function()
	{
		return capacity;
	}
}