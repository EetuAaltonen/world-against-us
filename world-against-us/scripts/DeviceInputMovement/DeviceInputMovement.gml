function DeviceInputMovement(_key_up, _key_down, _key_left, _key_right) constructor
{
	key_up = _key_up;
	key_down = _key_down;
	key_left = _key_left;
	key_right = _key_right;
	
	static Reset = function()
	{
		key_up = 0;
		key_down = 0;
		key_left = 0;
		key_right = 0;
	}
}