function ClearDSListAndDeleteValues(_dsList, _valueType = undefined)
{
	if (!is_undefined(_dsList))
	{
		if (ds_exists(_dsList, ds_type_list))
		{
			var listSize = ds_list_size(_dsList);
			repeat(listSize)
			{
				DeleteDSListValueByIndex(_dsList, 0, _valueType);
			}
			ds_list_clear(_dsList);
		} else {
			// TODO: Generic error handling
			show_debug_message("Unable to clear unknown DS list");
		}
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS list");
	}
}