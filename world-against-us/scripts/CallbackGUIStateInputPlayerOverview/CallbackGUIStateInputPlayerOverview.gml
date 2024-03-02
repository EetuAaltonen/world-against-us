function CallbackGUIStateInputPlayerOverview()
{
	if (IS_ROOM_IN_GAME_WORLD)
	{
		var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
		if (currentGUIState.index == GUI_STATE.PlayerOverview)
		{
			if (keyboard_check_released(ord("1")))
			{
				// OPEN PLAYER BACKPACK
				global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerBackpack, [
					CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1)
				], GUI_CHAIN_RULE.Overwrite);
			} else if (keyboard_check_released(ord("2")))
			{
				// OPEN PLAYER HEALTH STATUS
				global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerHealthStatus, [
					CreateWindowPlayerHealthStatus(GAME_WINDOW.PlayerHealthStatus, -1)
				], GUI_CHAIN_RULE.Overwrite);
			} else if (keyboard_check_released(ord("3")))
			{
				// OPEN PLAYER SKILLS
				global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.PlayerSkills, [
					CreateWindowPlayerSkills(GAME_WINDOW.PlayerSkills, -1)
				], GUI_CHAIN_RULE.Overwrite);
			}
		}
	}
}