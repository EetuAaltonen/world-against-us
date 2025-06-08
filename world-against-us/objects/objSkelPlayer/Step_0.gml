// INHERIT THE PARENT EVETN
event_inherited();

GetLocalPlayerMovementInput(movementInput);

var hInput = movementInput.key_right - movementInput.key_left;
var vInput = movementInput.key_down - movementInput.key_up;
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

if (place_meeting(x + hSpeed, y, objBlockParent))
{
	var meetInstance = instance_place(x + hSpeed, y, objBlockParent);
	if (meetInstance.mask_index != SPRITE_NO_MASK)
	{
		while (!place_meeting(x + sign(hSpeed), y, objBlockParent))
		{
			x += sign(hSpeed);
		}
		hSpeed = 0;
	}
}
x += hSpeed;

if (place_meeting(x, y + vSpeed, objBlockParent))
{
	var meetInstance = instance_place(x, y + vSpeed, objBlockParent);
	if (meetInstance.mask_index != SPRITE_NO_MASK)
	{
		while (!place_meeting(x, y + sign(vSpeed), objBlockParent))
		{
			y += sign(vSpeed);
		}
		vSpeed = 0;
	}
}
y += vSpeed;

// CALCULATE IMAGE X SCALE
var spriteDirection = CalculateSpriteDirectionToAim(new Vector2(x, y), MouseWorldPosition());
image_xscale = spriteDirection.image_x_scale;
