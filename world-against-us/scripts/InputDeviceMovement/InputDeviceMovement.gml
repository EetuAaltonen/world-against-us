function InputDeviceMovement(_enablePrevState) constructor
{
	key_up = 0;
	key_left = 0;
	key_down = 0;
	key_right = 0;
	
	// ENABLE PREVIOUS INPUT SNAPSHOTS
	previous_state = (_enablePrevState) ? new InputDeviceMovement(false) : undefined;
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.previous_state);
		_struct.previous_state = undefined;
	}
	
	static Update = function()
	{
		// UPDATE PREVIOUS STATE
		SnapshotToPrevState();
		
		// CHECK GUI STATE
		if (!global.GUIStateHandlerRef.IsGUIStateClosed())
		{
			ResetInput();
		} else {
			key_up = keyboard_check(ord("W"));
			key_left = keyboard_check(ord("A"));
			key_down = keyboard_check(ord("S"));
			key_right = keyboard_check(ord("D"));
		}
	}
	
	static SnapshotToPrevState = function()
	{
		if (!is_undefined(previous_state))
		{
			previous_state.key_up = key_up;
			previous_state.key_left = key_left;
			previous_state.key_down = key_down;
			previous_state.key_right = key_right;
		}
	}
	
	static ResetInput = function()
	{
		key_up = 0;
		key_left = 0;
		key_down = 0;
		key_right = 0;
	}
}