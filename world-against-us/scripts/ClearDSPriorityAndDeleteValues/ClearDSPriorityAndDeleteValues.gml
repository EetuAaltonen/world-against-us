function ClearDSPriorityAndDeleteValues(_dsPriority, _valueType = undefined)
{
	if (!is_undefined(_dsPriority))
	{
		var prioritySize = ds_priority_size(_dsPriority);
		repeat(prioritySize)
		{
			var value = ds_priority_find_min(_dsPriority);
			ReleaseVariableFromMemory(value, _valueType);
			ds_priority_delete_min(_dsPriority);	
		}
		ds_priority_clear(_dsPriority);
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS priority");
	}
}