var viewX = camera_get_view_x(view_camera[0]);
var viewY = camera_get_view_y(view_camera[0]);
var viewW = camera_get_view_width(view_camera[0]);
var viewH = camera_get_view_height(view_camera[0]);

var hInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var vInput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
var inputDir = point_direction(0, 0, hInput, vInput);

hSpeed += lengthdir_x(acceleration, inputDir);
if (hInput == 0)
{
	hSpeed = Approach(hSpeed, 0, acceleration * 2);
}
vSpeed += lengthdir_y(acceleration, inputDir);
if (vInput == 0)
{
	vSpeed = Approach(vSpeed, 0, acceleration * 2);
}

hSpeed = clamp(hSpeed, -maxSpeed, maxSpeed);
vSpeed = clamp(vSpeed, -maxSpeed, maxSpeed);
dirSpeed = sqrt((hSpeed * hSpeed) + (vSpeed * vSpeed));

if (place_meeting(x + hSpeed, y, objBlock))
{
	while (!place_meeting(x + sign(hSpeed), y, objBlock))
	{
		x += sign(hSpeed);
	}
	hSpeed = 0;
}
x += hSpeed;
var sprWidthCenter = sprite_get_width(sprite_index) * 0.5;
x = clamp(x, 0 + sprWidthCenter, room_width - sprWidthCenter);

if (place_meeting(x, y + vSpeed, objBlock))
{
	while (!place_meeting(x, y + sign(vSpeed), objBlock))
	{
		y += sign(vSpeed);
	}
	vSpeed = 0;
}
y += vSpeed;
var sprHeightCenter = sprite_get_height(sprite_index) * 0.5;
y = clamp(y, 0 + sprHeightCenter, room_height - sprHeightCenter);

var gotoX = x - (viewW * 0.5);
var gotoY = y - (viewH * 0.5);
gotoX = clamp(gotoX, 0, room_width - viewW);
gotoY = clamp(gotoY, 0, room_height - viewH);

var newX = lerp(viewX, gotoX, 0.1);
var newY = lerp(viewY, gotoY, 0.1);

camera_set_view_pos(view_camera[0], newX, newY);
