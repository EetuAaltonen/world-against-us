function MetadataConsumableLiquid(_consumable_type, _hydration) : Metadata() constructor
{
	consumable_type = _consumable_type;
    hydration = _hydration;
	
	static ToJSONStruct = function()
	{
		return {
			consumable_type: consumable_type,
			hydration: hydration
		}
	}
}