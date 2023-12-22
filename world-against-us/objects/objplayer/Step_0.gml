// OVERRIDE THE PARENT EVENT
character.Update();
if (character.is_dead) return;

if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
{
	// CHECK GUI STATE
	if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;
	GetLocalPlayerMovementInput();
	
	// QUICK HEAL
	if (keyboard_check_released(ord("Q")))
	{
		var medicine = FetchMedicineFromPockets();
		if (!is_undefined(medicine))
		{
			character.UseMedicine(medicine);
			if (medicine.metadata.healing_left <= 0)
			{
				medicine.sourceInventory.RemoveItemByGridIndex(medicine.grid_index);
			}
		} else {
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					"Quick healing failed, missing healing items",
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
	}
}

var hInput = key_right - key_left;
var vInput = key_down - key_up;
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

maxSpeed = (global.DEBUGMODE) ? 8 : baseMaxSpeed;
acceleration = (global.DEBUGMODE) ? 0.5 : baseAcceleration;

hSpeed = clamp(hSpeed, -maxSpeed, maxSpeed);
vSpeed = clamp(vSpeed, -maxSpeed, maxSpeed);
dirSpeed = sqrt((hSpeed * hSpeed) + (vSpeed * vSpeed));

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

var spriteDirection = CalculateSpriteDirectionToAim(new Vector2(x, y), MouseWorldPosition());
image_xscale = spriteDirection.image_x_scale;