function IsGUIStateInterruptible()
{
	var isInterruptible = true;
	if (!global.GUIStateHandlerRef.IsGUIStateClosed())
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		isInterruptible = (
			currentGUIState.index != GUI_STATE.GameOver &&
			currentGUIState.index != GUI_STATE.WorldMapFastTravelQueue
		);
	}
	return isInterruptible;
}