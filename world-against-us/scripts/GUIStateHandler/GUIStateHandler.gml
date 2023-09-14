function GUIStateHandler() constructor
{
	state_chain = [ROOT_GUI_STATE];
	
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
			array_push(state_chain, _guiState);
			isStateChanged = true;
		}
		return isStateChanged;
	}
	
	static RequestGUIView = function(_guiView, _windowIndexGroup)
	{
		var isViewChanged = false;
		if (!IsGUIStateClosed())
		{
			var currentGUIState = GetGUIState();
			if (!is_undefined(currentGUIState))
			{
				var newGUIState = currentGUIState.Clone();
				newGUIState.view = _guiView;
				newGUIState.windowIndexGroup = _windowIndexGroup;
				newGUIState.chainRule = GUI_CHAIN_RULE.OverwriteAll;
			
				isViewChanged = RequestGUIState(newGUIState);
			}
		} else {
			show_debug_message(string("Trying to request GUI view without open GUI state!"));
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
			newGUIState.chainRule = GUI_CHAIN_RULE.Append;
			
			isActionChanged = RequestGUIState(newGUIState);
		}
		return isActionChanged;
	}
	
	static GetGUIState = function()
	{
		return array_last(state_chain);
	}
	
	static CheckKeyboardInputGUIState = function()
	{
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (!IsGUIStateClosed())
			{
				if (IsKeyReleasedGUIStateClose() || currentGUIState.IsKeyReleasedAlternateGUIStateClose())
				{
					// CLOSE CURRENT GUI STATE
					CloseCurrentGUIState();
					
					// RESTORE DRAG ITEM IF GUI FULLY CLOSED
					if (IsGUIStateClosed())
					{
						if (!is_undefined(global.ObjMouse.dragItem))
						{
							global.ObjMouse.dragItem.RestoreOriginalItem();
							global.ObjMouse.dragItem = undefined;
						}
					}
				} else {
					currentGUIState.CallbackInputFunction();
				}
			} else {
				currentGUIState.CallbackInputFunction();
			}
		}
	}
	
	static ResetGUIState = function()
	{
		global.GameWindowHandlerRef.CloseAllWindows();
		state_chain = [ROOT_GUI_STATE];
	}
	
	static CloseCurrentGUIState = function()
	{
		if (array_length(state_chain) > 1)
		{
			var currentGUIState = array_pop(state_chain);
			// CLOSE CURRENT WINDOW
			global.GameWindowHandlerRef.CloseWindowGroupByIndexGroup(currentGUIState.windowIndexGroup);
		} else {
			show_message("Invalid 'CloseCurrentGUIState' call. GUI state already closed!");
		}
	}
	
	static IsGUIStateClosed = function()
	{
		var isGUIStateClosed = true;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (currentGUIState.index != GUI_STATE.GameRoot)
			{
				isGUIStateClosed = (
					currentGUIState.index == GUI_STATE.GameRoot || (currentGUIState.index == GUI_STATE.MainMenu && is_undefined(currentGUIState.view))
				);
			}
		} else {
			show_debug_message(string("Current GUI state is undefined!"));
		}
		return isGUIStateClosed;
	}
}