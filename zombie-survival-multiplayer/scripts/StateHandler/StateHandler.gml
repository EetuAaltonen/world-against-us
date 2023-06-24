function StateHandler() constructor
{
	undefinedState = new GUIState(undefined, undefined, undefined, []);
	stateChain = [undefinedState];
	
	static RequestGUIState = function(_guiState)
	{
		var isStateChanged = false;
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
	
	static RequestGUIView = function(_guiView, _windowIndexGroup)
	{
		var isViewChanged = false;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			var newGUIState = currentGUIState.Clone();
			newGUIState.view = _guiView;
			newGUIState.windowIndexGroup = _windowIndexGroup;
			
			isViewChanged = RequestGUIState(newGUIState);
		}
		return isViewChanged;
	}
	
	static RequestGUIAction = function(_guiAction, _windowIndexGroup)
	{
		var isActionChanged = false;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			var newGUIState = currentGUIState.Clone();
			newGUIState.action = _guiAction;
			newGUIState.windowIndexGroup = _windowIndexGroup;
			
			isActionChanged = RequestGUIState(newGUIState);
		}
		return isActionChanged;
	}
	
	static GetGUIState = function()
	{
		return array_last(stateChain);
	}
	
	static CheckKeyboardInputGUIState = function()
	{
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (IsKeyReleasedGUIStateClose() || currentGUIState.IsKeyReleasedAlternateGUIStateClose())
			{
				if (currentGUIState.index != GUI_STATE.MainMenu ||
				(currentGUIState.index == GUI_STATE.MainMenu && !is_undefined(currentGUIState.view)))
				{
					// RESET DRAG ITEM
					global.ObjMouse.dragItem = undefined;
					
					// CLOSE CURRENT GUI STATE
					CloseCurrentGUIState();
				}
			} else {
				currentGUIState.CallbackInputFunction();
			}
		}
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