function Facility(_facility_id, _inventory, _type, _metadata) constructor
{
	facility_id = _facility_id;
	type = _type;
	inventory = _inventory;
	metadata = _metadata;
	
	static ToJSONStruct = function()
	{
		var formatInventory = !is_undefined(inventory) ? inventory.ToJSONStruct() : inventory;
		var formatMetadata = !is_undefined(metadata) ? metadata.ToJSONStruct(metadata) : metadata;
		return {
			facility_id: facility_id,
			type: type,
			inventory: formatInventory,
			metadata: formatMetadata
		}
	}
}