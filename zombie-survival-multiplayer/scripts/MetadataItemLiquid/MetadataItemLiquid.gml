function MetadataItemLiquid(_hydration) : Metadata() constructor
{
    hydration = _hydration;
	
	static ToJSONStruct = function()
	{
		return {
			// NO DYNAMIC METADATA
		}
	}
}