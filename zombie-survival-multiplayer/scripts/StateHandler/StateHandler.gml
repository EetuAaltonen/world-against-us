function StateHandler() constructor
{
	undefinedState = new GUIState(undefined, undefined, undefined, []);
	stateChain = [undefinedState];
	
	static RequestGUIState = function(_guiState)
	{
		isStateChanged = false;
		var currentGUIState = GetGUIState();
		// SKIP IF GUI STATE NOT CHANGED
		if (_guiState.index != currentGUIState.index ||
			_guiState.view != currentGUIState.view ||
			_guiState.action != currentGUIState.action)
		{
			// OVERWRITE GUI STATE
			if (_guiState.chainRule == GUI_CHAIN_RULE.Overwrite) {
				CloseCurrentGUIState();
			} else if (_guiState.chainRule == GUI_CHAIN_RULE.OverwriteAll)
			{
				ResetGUIState();
			}
			
			// PUSH NEW GUI STATE TO CHAIN
			array_push(stateChain, _guiState);
			isStateChanged = true;
		}
		return isStateChanged;
	}
	
	static GetGUIState = function()
	{
		return array_last(stateChain);
	}
	
	static ResetGUIState = function()
	{
		global.GameWindowHandler.CloseAllWindows();
		array_delete(stateChain, 1, array_length(stateChain));
	}
	
	static CloseCurrentGUIState = function()
	{
		var currentGUIState = array_pop(stateChain);
		// CLOSE CURRENT WINDOW
		global.GameWindowHandler.CloseWindowGroupByIndexGroup(currentGUIState.windowIndexGroup);
	}
	
	static IsGUIStateClosed = function()
	{
		return is_undefined(GetGUIState().index);
	}
}