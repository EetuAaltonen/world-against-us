function ClearDSListAndDeleteValues(_dsList)
{
	if (!is_undefined(_dsList))
	{
		var listSize = ds_list_size(_dsList);
		repeat(listSize)
		{
			ds_list_delete(_dsList, 0);	
		}
		ds_list_clear(_dsList);
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS list");
	}
}