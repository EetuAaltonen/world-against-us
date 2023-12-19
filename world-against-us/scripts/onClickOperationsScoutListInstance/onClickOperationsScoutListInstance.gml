function onClickOperationsScoutListInstance()
{
	var availableInstance = elementData;
	if (!is_undefined(availableInstance))
	{
		global.MapDataHandlerRef.SetTargetScoutInstance(availableInstance);
	}
}