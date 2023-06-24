function CallbackGUIStateInputPlayerOverview()
{
	if (room != roomMainMenu)
	{
		var currentGUIState = global.GUIStateHandler.GetGUIState();
		if (currentGUIState.index == GUI_STATE.PlayerOverview)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN PLAYER BACKPACK
				if (global.GUIStateHandler.RequestGUIView(GUI_VIEW.PlayerBackpack, [GAME_WINDOW.PlayerBackpack]))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerBackpack(-1)
					]);
				}
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN PLAYER HEALTH STATUS
				if (global.GUIStateHandler.RequestGUIView(GUI_VIEW.PlayerHealthStatus, [GAME_WINDOW.PlayerHealthStatus]))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerHealthStatus(-1)
					]);
				}
			} else if (keyboard_check_released(ord("3")))
			{
				// OPEN PLAYER SKILLS
				if (global.GUIStateHandler.RequestGUIView(GUI_VIEW.PlayerSkills, [GAME_WINDOW.PlayerSkills]))
				{
					global.GameWindowHandler.OpenWindowGroup([
						CreateWindowPlayerSkills(-1)
					]);
				}
			}
		}
	}
}