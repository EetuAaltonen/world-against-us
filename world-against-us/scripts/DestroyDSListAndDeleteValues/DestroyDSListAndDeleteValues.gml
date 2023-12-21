function DestroyDSListAndDeleteValues(_dsListRef, _valueType = undefined){
	ClearDSListAndDeleteValues(_dsListRef, _valueType);
	ds_list_destroy(_dsListRef);
}