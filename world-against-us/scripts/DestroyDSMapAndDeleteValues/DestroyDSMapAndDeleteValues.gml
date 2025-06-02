function DestroyDSMapAndDeleteValues(_dsMapRef, _valueType = undefined)
{
	if (!is_undefined(_dsMapRef))
	{
		if (ds_exists(_dsMapRef, ds_type_map))
		{
			ClearDSMapAndDeleteValues(_dsMapRef, _valueType);
			ds_map_destroy(_dsMapRef);
		}
	}
}