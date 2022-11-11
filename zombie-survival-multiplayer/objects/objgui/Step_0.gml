if (IsGUIStateClosed())
{
	if (keyboard_check_released(vk_tab))
	{
		RequestGUIState(GUI_STATE.PlayerBackpack);
	}
} else {
	if (keyboard_check_released(vk_tab) ||
		keyboard_check_released(vk_escape))
	{
		RequestGUIState(undefined);
	}
}
