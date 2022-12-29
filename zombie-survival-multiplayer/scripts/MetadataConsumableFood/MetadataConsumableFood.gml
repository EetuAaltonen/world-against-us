function MetadataConsumableFood(_consumable_type, _nutrition) : Metadata() constructor
{
	consumable_type = _consumable_type;
    nutrition = _nutrition;
	
	static ToJSONStruct = function()
	{
		return {
			consumable_type: consumable_type,
			nutrition: nutrition
		}
	}
}