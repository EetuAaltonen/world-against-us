function IsGUIStateClosed() {
	return (global.GUIState == GUI_STATE.Noone);
}

function RequestGUIState(_newGUIState)
{
	var stateUpdated = true;
	if (_newGUIState == global.GUIState) { return stateUpdated; }
	global.GUIState = _newGUIState;
}
