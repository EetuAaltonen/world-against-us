function Facility(_facility_id, _inventory, _type, _metadata) constructor
{
	facility_id = _facility_id;
	inventory = _inventory;
	type = _type;
	metadata = _metadata;
	
	static ToJSONStruct = function()
	{
		var itemsArray = !is_undefined(inventory) ? inventory.ToJSONStruct().items : [];
		return {
			facility_id: facility_id,
			items: itemsArray
		}
	}
}