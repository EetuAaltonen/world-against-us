function DestroyDSMapAndDeleteValues(_dsMapRef, _valueType = undefined)
{
	ClearDSMapAndDeleteValues(_dsMapRef, _valueType);
	ds_map_destroy(_dsMapRef);
}