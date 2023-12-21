function DeleteDSListValueByIndex(_dsListRef, _index, _valueType = undefined)
{
	var value = _dsListRef[| _index];
	ReleaseVariableFromMemory(value, _valueType);
	ds_list_delete(_dsListRef, _index);
}