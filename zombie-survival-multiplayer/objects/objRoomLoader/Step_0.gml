roomFadeAlpha = Approach(roomFadeAlpha, 0, roomFadeAlphaStep);

if (keyboard_check_released(ord("M")))
{
	// GO BACK TO MAIN MENU
	room_goto(roomMainMenu);
}