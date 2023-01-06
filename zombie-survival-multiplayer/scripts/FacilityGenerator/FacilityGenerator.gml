function FacilityGenerator(_facility_id, _inventory, _tank_capacity) : Facility(_facility_id, _inventory) constructor
{
	tank_capacity = _tank_capacity;
	fuel_level = 0;
	
	static ToJSONStruct = function()
	{
		var itemsArray = !is_undefined(inventory) ? inventory.ToJSONStruct().items : [];
		return {
			facility_id: facility_id,
			items: itemsArray,
			
			tank_capacity: tank_capacity,
			fuel_level: fuel_level
		}
	}
}