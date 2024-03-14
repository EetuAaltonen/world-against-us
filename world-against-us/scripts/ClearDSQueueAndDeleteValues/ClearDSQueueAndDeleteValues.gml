function ClearDSQueueAndDeleteValues(_dsQueue, _valueType = undefined)
{
	if (!is_undefined(_dsQueue))
	{
		if (ds_exists(_dsQueue, ds_type_queue))
		{
			var prioritySize = ds_queue_size(_dsQueue);
			repeat(prioritySize)
			{
				var value = ds_queue_dequeue(_dsQueue);
				ReleaseVariableFromMemory(value, _valueType);
			}
			ds_queue_clear(_dsQueue);
		} else {
			// TODO: Generic error handling
			show_debug_message("Unable to clear unknown DS queue");
		}
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS queue");
	}
}