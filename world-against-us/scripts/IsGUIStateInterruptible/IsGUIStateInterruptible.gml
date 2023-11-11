function IsGUIStateInterruptible()
{
	var isInterruptible = true;
	if (!global.GUIStateHandlerRef.IsGUIStateClosed())
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		isInterruptible = (currentGUIState.index != GUI_STATE.GameOver && currentGUIState.action != GUI_ACTION.WorldMapFastTravelQueue);
	}
	return isInterruptible;
}