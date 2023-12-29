function DeleteDSMapValueByKey(_dsMapRef, _key, _valueType = undefined)
{
	var value = _dsMapRef[$ _key];
	ReleaseVariableFromMemory(value, _valueType);
	ds_map_delete(_dsMapRef, _key);
}