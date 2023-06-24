// CHECK GUI STATE
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

// AIM WITH WEAPON
if (owner.character.type == CHARACTER_TYPE.PLAYER)
{
	var aimButton = mb_right;
	if (mouse_check_button(aimButton))
	{
		if (!is_undefined(primaryWeapon))
		{
			isAiming = true;
		}
	} else if (mouse_check_button_released(aimButton))
	{
		isAiming = false;
	}
}
