function ClearDSListAndDeleteValues(_dsList, _valueType = undefined)
{
	if (!is_undefined(_dsList))
	{
		var listSize = ds_list_size(_dsList);
		repeat(listSize)
		{
			var value = _dsList[| 0];
			ReleaseVariableFromMemory(value, _valueType);
			ds_list_delete(_dsList, 0);	
		}
		ds_list_clear(_dsList);
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS list");
	}
}