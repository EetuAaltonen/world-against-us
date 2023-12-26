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
				if (!ResetGUIState())
				{
					show_debug_message("Failed to reset GUI state");	
				}
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
				newGUIState.chainRule = GUI_CHAIN_RULE.Overwrite;
			
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
	
	static IsCurrentGUIStateGameWindowOpen = function(_gameWindowId)
	{
		var isWindowOpen = false;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			isWindowOpen = ArrayContainsValue(currentGUIState.windowIndexGroup, _gameWindowId);
		}
		return isWindowOpen;
	}
	
	static CheckKeyboardInputGUIState = function()
	{
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (!IsKeyReleasedGUIStateConsole())
			{
				if (!IsGUIStateClosed())
				{
					// CHECK IF GAME OVER OR FAST TRAVEL QUEUE NOT IN-PROGRESS
					if (IsGUIStateInterruptible())
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
					}
				} else {
					currentGUIState.CallbackInputFunction();
				}
			} else {
				// OPEN CONSOLE
				if (currentGUIState.index != GUI_STATE.Console)
				{
					var appendWindowIndex = -1;
					var currentWindowIndex = currentGUIState.windowIndexGroup[@ 0];
					if (!is_undefined(currentWindowIndex))
					{
						var currentWindow = global.GameWindowHandlerRef.GetWindowById(currentWindowIndex);
						if (!is_undefined(currentWindow))
						{
							appendWindowIndex = currentWindow.zIndex - 1;	
						}
					}
					
					var testMessage = new ConsoleLog(CONSOLE_LOG_TYPE.INFO, "Test message...");
					global.ConsoleHandlerRef.AddConsoleLog(testMessage);
					var consoleMessages = ds_list_create();
					ds_list_copy(consoleMessages, global.ConsoleHandlerRef.console_messages);
					var guiState = new GUIState(
						GUI_STATE.Console, undefined, undefined,
						[GAME_WINDOW.Console], GUI_CHAIN_RULE.Append,
						undefined, undefined
					);
					if (global.GUIStateHandlerRef.RequestGUIState(guiState))
					{
						global.GameWindowHandlerRef.OpenWindowGroup([
							CreateWindowConsole(GAME_WINDOW.Console, appendWindowIndex, consoleMessages)
						]);
					}
				}
			}
		}
	}
	
	static ResetGUIState = function()
	{
		var isGUIStateReseted = true;
		global.GameWindowHandlerRef.CloseAllWindows();
		state_chain = [ROOT_GUI_STATE];
		return isGUIStateReseted;
	}
	
	static ResetGUIStateMainMenu = function()
	{
		var isGUIStateMainMenuReseted = false;
		// OPEN MAIN MENU ROOT WINDOW
		var guiState = new GUIState(
			GUI_STATE.MainMenu, undefined, undefined,
			[GAME_WINDOW.MainMenuRoot], GUI_CHAIN_RULE.OverwriteAll
		);
		if (RequestGUIState(guiState))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowMainMenuRoot(GAME_WINDOW.MainMenuRoot, 0)
			]);
			isGUIStateMainMenuReseted = true;
		}
		return isGUIStateMainMenuReseted;
	}
	
	static CloseCurrentGUIState = function()
	{
		var isGUIStateClosed = false;
		if (array_length(state_chain) > 1)
		{
			var currentGUIState = array_pop(state_chain);
			// CLOSE CURRENT WINDOW
			if (global.GameWindowHandlerRef.CloseWindowGroupByIndexGroup(currentGUIState.windowIndexGroup))
			{
				isGUIStateClosed = true;
			}
		} else {
			// TODO: Generic error handling
			show_message("Invalid 'CloseCurrentGUIState' call. GUI state already closed!");
		}
		return isGUIStateClosed;
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