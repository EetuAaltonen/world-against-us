function Metadata() constructor
{
	// BASE CLASS TO OVERRIDE
	
	static ToJSONStruct = function()
	{
		// OVERRIDE THIS FUNCTION
		return EMPTY_STRUCT;
	}
	
	static OnDestroy = function()
	{
		// OVERRIDE THIS FUNCTION
		// NO PROPERTIES TO DESTROY
	}
}