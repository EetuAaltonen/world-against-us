function KeyboardReleasedCloseWindow()
{
	return keyboard_check_released(vk_tab) || keyboard_check_released(vk_escape);
}