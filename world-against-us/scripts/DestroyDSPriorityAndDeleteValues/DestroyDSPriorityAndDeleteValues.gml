function DestroyDSPriorityAndDeleteValues(_dsPriorityRef, _valueType = undefined)
{
	if (!is_undefined(_dsPriorityRef))
	{
		ClearDSPriorityAndDeleteValues(_dsPriorityRef, _valueType);
		ds_priority_destroy(_dsPriorityRef);
	}
}