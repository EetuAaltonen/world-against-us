function GUIStateHandler() constructor
{
	state_chain = [ROOT_GUI_STATE];
	gui_state_queue = undefined;
	gui_state_reset = false;
	gui_state_close_current = false;
	
	static RequestGUIState = function(_guiState)
	{
		var isStateQueued = false;
		var currentGUIState = GetGUIState();
		// SKIP IF GUI STATE NOT CHANGED
		if (_guiState.index != currentGUIState.index ||
			_guiState.view != currentGUIState.view ||
			_guiState.action != currentGUIState.action)
		{
			gui_state_queue = _guiState;
			isStateQueued = true;
		}
		return isStateQueued;
	}
	
	static RequestGUIView = function(_guiView, _windowGroup, _chainRule)
	{
		var isViewChanged = false;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (currentGUIState.index != GUI_STATE.GameRoot)
			{
				var newGUIState = currentGUIState.Clone();
				newGUIState.view = _guiView;
				newGUIState.windowGroup = _windowGroup;
				newGUIState.chainRule = _chainRule;
			
				isViewChanged = RequestGUIState(newGUIState);
			} else {
				show_debug_message(string("Trying to request GUI view without open GUI state!"));
			}
		}
		return isViewChanged;
	}
	
	static RequestGUIAction = function(_guiAction, _windowGroup, _chainRule)
	{
		var isActionChanged = false;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			if (currentGUIState.index != GUI_STATE.GameRoot)
			{
				var newGUIState = currentGUIState.Clone();
				newGUIState.action = _guiAction;
				newGUIState.windowGroup = _windowGroup;
				newGUIState.chainRule = _chainRule;
			
				isActionChanged = RequestGUIState(newGUIState);
			} else {
				show_debug_message(string("Trying to request GUI action without open GUI state!"));
			}
		}
		return isActionChanged;
	}
	
	static CheckGUIStateQueueAndProceed = function()
	{
		if (!is_undefined(gui_state_queue))
		{
			// OVERWRITE GUI STATE
			if (gui_state_queue.chainRule == GUI_CHAIN_RULE.Overwrite) {
				CloseCurrentGUIState();
			} else if (gui_state_queue.chainRule == GUI_CHAIN_RULE.OverwriteAll)
			{
				if (room == roomMainMenu)
				{
					ResetGUIStateMainMenu();
				} else {
					ResetGUIState();
				}
			}
			// SET GUI STATE
			SetGUIState(gui_state_queue);
		} else if (gui_state_reset)
		{
			if (room == roomMainMenu)
			{
				ResetGUIStateMainMenu();
			} else {
				ResetGUIState();
			}
		} else if (gui_state_close_current)
		{
			CloseCurrentGUIState();	
		}
		
		// RESET GUI STATE QUEUE
		gui_state_queue = undefined;
		gui_state_reset = false;
		gui_state_close_current = false;
	}
	
	static SetGUIState = function(_guiState)
	{
		var isGUIStateSet = false;
		var windowGroup = _guiState.windowGroup;
		if (!is_undefined(windowGroup))
		{
			// PUSH NEW GUI STATE TO CHAIN
			array_push(state_chain, _guiState);
			// OPEN WINDOW GROUP
			global.GameWindowHandlerRef.OpenWindowGroup(windowGroup);
			isGUIStateSet = true;
		}
		return isGUIStateSet;
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
			var windowCount = array_length(currentGUIState.windowGroup);
			for (var i = 0; i < windowCount; i++)
			{
				var gameWindow = currentGUIState.windowGroup[@ i];
				if (gameWindow.windowId == _gameWindowId)
				{
					isWindowOpen = true;
					break;
				}
			}
		}
		return isWindowOpen;
	}
	
	static CheckKeyboardInputGUIState = function()
	{
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
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
		}
	}
	
	static RequestGUIStateReset = function()
	{
		gui_state_reset = true;	
	}
	
	static ResetGUIState = function()
	{
		var isGUIStateReseted = true;
		// CLOSE WINDOWS
		global.GameWindowHandlerRef.CloseAllWindows();
		// SET ROOT GUI STATE CHAIN
		state_chain = [ROOT_GUI_STATE];
		return isGUIStateReseted;
	}
	
	static ResetGUIStateMainMenu = function()
	{
		var isGUIStateMainMenuReseted = false;
		// CLOSE ALL WINDOWS
		global.GameWindowHandlerRef.CloseAllWindows();
		// RESET GUI STATE CHAIN
		state_chain = [];
		// OPEN MAIN MENU ROOT WINDOW
		var guiState = new GUIState(
			GUI_STATE.MainMenu, undefined, undefined,
			[
				CreateWindowMainMenuRoot(GAME_WINDOW.MainMenuRoot, 0)
			],
			GUI_CHAIN_RULE.Append
		);
		isGUIStateMainMenuReseted = SetGUIState(guiState);
		return isGUIStateMainMenuReseted;
	}
	
	static RequestCloseCurrentGUIState = function()
	{
		gui_state_close_current = true;	
	}
	
	static CloseCurrentGUIState = function()
	{
		var isGUIStateClosed = false;
		if (array_length(state_chain) > 1)
		{
			var currentGUIState = array_pop(state_chain);
			// CLOSE CURRENT WINDOWS
			if (global.GameWindowHandlerRef.CloseWindowGroup(currentGUIState.windowGroup))
			{
				isGUIStateClosed = true;
			}
		} else {
			// TODO: Generic error handling
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, "Invalid 'CloseCurrentGUIState' call. GUI state already closed!");
		}
		return isGUIStateClosed;
	}
	
	static IsGUIStateClosed = function()
	{
		var isGUIStateClosed = true;
		var currentGUIState = GetGUIState();
		if (!is_undefined(currentGUIState))
		{
			isGUIStateClosed = (
				currentGUIState.index == GUI_STATE.GameRoot ||
				(currentGUIState.index == GUI_STATE.MainMenu && is_undefined(currentGUIState.view) && is_undefined(currentGUIState.action))
			);
		} else {
			show_debug_message(string("Current GUI state is undefined!"));
		}
		return isGUIStateClosed;
	}
}