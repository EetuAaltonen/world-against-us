function MetadataItemFood(_nutrition) : Metadata() constructor
{
    nutrition = _nutrition;
	
	static ToJSONStruct = function()
	{
		return {
			// NO DYNAMIC METADATA
		}
	}
}