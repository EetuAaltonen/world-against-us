function FacilityRoadGate(_facility_id, _inventory, _is_open) : Facility(_facility_id, _inventory) constructor
{
	is_open = _is_open;
	
	static ToJSONStruct = function()
	{	
		var itemsArray = !is_undefined(inventory) ? inventory.ToJSONStruct().items : [];
		return {
			facility_id: facility_id,
			items: itemsArray,
			
			is_open: is_open
		}
	}
}