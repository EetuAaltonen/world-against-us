var key_up = keyboard_check(vk_up);
var key_down = keyboard_check(vk_down);
var key_left = keyboard_check(vk_left);
var key_right = keyboard_check(vk_right);
		
var hInput = key_right - key_left;
var vInput = key_down - key_up;

if (hInput != 0)
{
	x += sign(hInput) * movementSpeed;
	x = clamp(x, 0, room_width);
}
if (vInput != 0)
{
	y += sign(vInput) * movementSpeed;
	y = clamp(y, 0, room_height);
}