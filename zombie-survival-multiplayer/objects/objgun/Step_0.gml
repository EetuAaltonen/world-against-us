// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

// AIM WITH WEAPON
var aimButton = mb_right;
if (mouse_check_button(aimButton))
{
	if (primaryWeapon != noone)
	{
		isAiming = true;
	}
} else if (mouse_check_button_released(aimButton))
{
	isAiming = false;
}
