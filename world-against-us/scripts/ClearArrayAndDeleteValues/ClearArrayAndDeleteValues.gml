function ClearArrayAndDeleteValues(_arrayRef, _valueType = undefined)
{
	if (!is_undefined(_arrayRef))
	{
		if (is_array(_arrayRef))
		{
			var arrayLength = array_length(_arrayRef);
			repeat(arrayLength)
			{
				var value = _arrayRef[@ 0];
				ReleaseVariableFromMemory(value, _valueType);
				array_delete(_arrayRef, 0, 1);
			}
		} else {
			// TODO: Generic error handling
			show_debug_message("Unable to clear unknown DS list");
		}
	} else {
		// TODO: Generic error handling
		show_debug_message("Unable to clear undefined DS list");
	}
}