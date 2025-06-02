function DestroyDSListAndDeleteValues(_dsListRef, _valueType = undefined)
{
	if (!is_undefined(_dsListRef))
	{
		if (ds_exists(_dsListRef, ds_type_list))
		{
			ClearDSListAndDeleteValues(_dsListRef, _valueType);
			ds_list_destroy(_dsListRef);
		}
	}
}