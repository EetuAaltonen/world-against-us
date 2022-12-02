if (room == roomMap1)
{
	if (IsGUIStateClosed())
	{
		if (keyboard_check_released(vk_tab))
		{
			RequestGUIState(GUI_STATE.PlayerBackpack);
		}
	} else {
		if (KeyboardReleasedCloseWindow())
		{
			RequestGUIState(undefined);
		}
	}
} 