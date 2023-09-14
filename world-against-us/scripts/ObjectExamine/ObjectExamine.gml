function ObjectExamine(_object_name, _display_name, _icon, _description) constructor
{
	object_name = _object_name;
	display_name = _display_name;
	icon = _icon;
	description = _description;
	
	static ToJSONStruct = function()
	{
		return {
			// NO DYNAMIC DATA
		}
	}
}