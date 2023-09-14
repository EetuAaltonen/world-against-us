function CallbackGUIStateInputPlayerOverview()
{
	if (room != roomMainMenu)
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		if (currentGUIState.index == GUI_STATE.PlayerOverview)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN PLAYER BACKPACK
				if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerBackpack, [GAME_WINDOW.PlayerBackpack]))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN PLAYER HEALTH STATUS
				if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerHealthStatus, [GAME_WINDOW.PlayerHealthStatus]))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowPlayerHealthStatus(GAME_WINDOW.PlayerHealthStatus, -1)
					]);
				}
			} else if (keyboard_check_released(ord("3")))
			{
				// OPEN PLAYER SKILLS
				if (global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerSkills, [GAME_WINDOW.PlayerSkills]))
				{
					global.GameWindowHandlerRef.OpenWindowGroup([
						CreateWindowPlayerSkills(GAME_WINDOW.PlayerSkills, -1)
					]);
				}
			}
		}
	}
}