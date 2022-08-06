if (keyboard_check_released(vk_tab))
{
	if (IsGUIStateClosed())
	{
		RequestGUIState(GUI_STATE.PlayerBackpack);
	} else if (global.GUIState == GUI_STATE.PlayerBackpack ||
				global.GUIState == GUI_STATE.LootContainer)
	{
		RequestGUIState(GUI_STATE.Noone);
	}
} else if (keyboard_check_released(vk_escape))
{
	if (global.GUIState == GUI_STATE.PlayerBackpack ||
		global.GUIState == GUI_STATE.LootContainer)
	{
		RequestGUIState(GUI_STATE.Noone);
	}
}
