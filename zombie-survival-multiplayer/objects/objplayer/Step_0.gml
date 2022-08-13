if (character.type == CHARACTER_TYPE.PLAYER)
{
	// INHERITED EVENT
	event_inherited();

	// CHECK GUI STATE
	if (!IsGUIStateClosed()) return;

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

	if (place_meeting(x + hSpeed, y, objBlockParent))
	{
		while (!place_meeting(x + sign(hSpeed), y, objBlockParent))
		{
			x += sign(hSpeed);
		}
		hSpeed = 0;
	}
	x += hSpeed;
	var sprWidthCenter = sprite_get_width(sprite_index) * 0.5;
	x = clamp(x, 0 + sprWidthCenter, room_width - sprWidthCenter);

	if (place_meeting(x, y + vSpeed, objBlockParent))
	{
		while (!place_meeting(x, y + sign(vSpeed), objBlockParent))
		{
			y += sign(vSpeed);
		}
		vSpeed = 0;
	}
	y += vSpeed;
	var sprHeightCenter = sprite_get_height(sprite_index) * 0.5;
	y = clamp(y, 0 + sprHeightCenter, room_height - sprHeightCenter);
} else {
	if (timeElapsed < lerpDuration)
	{
	    x = lerp(startLocation.X, targetLocation.X, timeElapsed / lerpDuration);
		y = lerp(startLocation.Y, targetLocation.Y, timeElapsed / lerpDuration);
	    timeElapsed++;
	}
	else 
	{
		startLocation = targetLocation;
	    x = targetLocation.X;
		y = targetLocation.Y;
		timeElapsed = 0;
	}
}
