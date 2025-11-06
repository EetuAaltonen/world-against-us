function InputDeviceMouse() constructor
{
	mb_left_pressed = undefined;
	mb_left_hold_down = undefined;
	mb_left_released = undefined;
	
	// INIT
	ResetInput();
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static Update = function()
	{
		// CHECK GUI STATE
		if (!global.GUIStateHandlerRef.IsGUIStateClosed())
		{
			ResetInput();
		} else {
			mb_left_pressed = mouse_check_button_pressed(mb_left);
			mb_left_hold_down = mouse_check_button(mb_left);
			mb_left_released = mouse_check_button_released(mb_left);
		}
	}
	
	static ResetInput = function()
	{
		mb_left_pressed = 0;
		mb_left_hold_down = 0;
		mb_left_released = 0;
	}
}