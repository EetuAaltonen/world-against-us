function DestroyDSPriorityAndDeleteValues(_dsPriorityRef, _valueType = undefined)
{
	if (!is_undefined(_dsPriorityRef))
	{
		if (ds_exists(_dsPriorityRef, ds_type_priority))
		{
			ClearDSPriorityAndDeleteValues(_dsPriorityRef, _valueType);
			ds_priority_destroy(_dsPriorityRef);
		}
	}
}