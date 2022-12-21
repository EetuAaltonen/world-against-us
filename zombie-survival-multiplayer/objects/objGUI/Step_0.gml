if (stateHandler.IsGUIStateClosed())
{
	if (room != roomMainMenu)
	{
		if (keyboard_check_released(vk_tab))
		{
			// OPEN PLAYER BACKPACK
			var guiState = new GUIState(
				GUI_STATE.PlayerOverview, GUI_VIEW.Backpack, undefined,
				[GAME_WINDOW.PlayerBackpack], GUI_CHAIN_RULE.OverwriteAll
			);
			if (global.GUIStateHandler.RequestGUIState(guiState))
			{
				global.GameWindowHandler.OpenWindowGroup([
					CreateWindowPlayerBackpack(-1)
				]);
			}
		}
	}
} else {
	var currentGUIState = stateHandler.GetGUIState();
	if (KeyboardReleasedCloseWindow())
	{
		if (currentGUIState.index != GUI_STATE.MainMenu ||
			(currentGUIState.index == GUI_STATE.MainMenu && !is_undefined(currentGUIState.view)))
		{
			stateHandler.CloseCurrentGUIState();
		}
	} else if (room != roomMainMenu)
	{
		if (currentGUIState.index == GUI_STATE.PlayerOverview)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN PLAYER BACKPACK
				var guiState = new GUIState(
					currentGUIState.index, GUI_VIEW.Backpack, undefined,
					[GAME_WINDOW.PlayerBackpack], GUI_CHAIN_RULE.OverwriteAll
				);
				if (global.GUIStateHandler.RequestGUIState(guiState))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerBackpack(-1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN PLAYER HEALTH STATUS
				var guiState = new GUIState(
					currentGUIState.index, GUI_VIEW.HealthStatus, undefined,
					[GAME_WINDOW.PlayerHealthStatus], GUI_CHAIN_RULE.OverwriteAll
				);
				if (global.GUIStateHandler.RequestGUIState(guiState))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerHealthStatus(-1)
					]);
				}
			} else if (keyboard_check_released(ord("3")))
			{
				// OPEN PLAYER SKILLS
				var guiState = new GUIState(
					currentGUIState.index, GUI_VIEW.Skills, undefined,
					[GAME_WINDOW.PlayerSkills], GUI_CHAIN_RULE.OverwriteAll
				);
				if (global.GUIStateHandler.RequestGUIState(guiState))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerSkills(-1)
					]);
				}
			}
		}
	}
}