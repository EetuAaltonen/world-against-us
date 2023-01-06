function MetadataFacilityGenerator(_fuel_tank_capacity, _fuel_level) : Metadata() constructor
{
	fuel_tank_capacity = _fuel_tank_capacity;
	fuel_level = _fuel_level;
	
	static ToJSONStruct = function()
	{
		return {
			fuel_tank_capacity: fuel_tank_capacity,
			fuel_level: fuel_level
		}
	}
}