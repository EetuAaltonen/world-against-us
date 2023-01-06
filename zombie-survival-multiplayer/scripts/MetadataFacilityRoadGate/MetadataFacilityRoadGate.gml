function MetadataFacilityRoadGate(_is_open) : Metadata() constructor
{
	is_open = _is_open;
	
	static ToJSONStruct = function()
	{
		return {
			is_open: is_open
		}
	}
}