function GetLocalPlayerInputAction()
{
	// ACTIONS THAT DON'T INTERUPT OTHER ACTIONS
	var actionHandlerRef = character.action_handler;
	if (is_undefined(actionHandlerRef.active_action))
	{
		// SHOOT WEAPON
		if (inputDeviceMouse.mb_left_pressed || inputDeviceMouse.mb_left_hold_down)
		{
			if (!actionHandlerRef.IsActionInCooldown(CHARACTER_ACTION.SHOOT))
			{
				var primaryWeaponRef = character.gear.GetItemBySlot(character.gear.primary_weapon);
				if (!is_undefined(primaryWeaponRef))
				{
					var firingModeIndex = primaryWeaponRef.metadata.firing_mode_index;
					var firingMode = primaryWeaponRef.metadata.firing_modes[firingModeIndex];
					if (inputDeviceMouse.mb_left_pressed || (inputDeviceMouse.mb_left_hold_down && firingMode == FIRING_MODE_AUTO))
					{
						var actionResult = CharacterActionWeaponGunShoot(self, mouse_x, mouse_y);
						if (actionResult != CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.SHOT)
						{
							// ACTION FAILED
						}
					}
				}
			}
		} else if (keyboard_check_released(ord("R")))
		{
			if (actionHandlerRef.GetActionIndex() != CHARACTER_ACTION.RELOAD)
			{
				if (!actionHandlerRef.IsActionInCooldown(CHARACTER_ACTION.RELOAD))
				{
					var actionResult = CharacterActionWeaponGunReload(self);
					if (actionResult != CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED)
					{
						// ACTION FAILED
					}
				}
			}
		} else if (keyboard_check_released(ord("V")))
		{
			var actionResult = CharacterActionWeaponGunSwitchFiringMode(self);
			if (actionResult != CHARACTER_ACTION_RESULT_WEAPON_GUN_SWITCH_FIRING_MODE.SWITCHED)
			{
				// ACTION FAILED
			}
		}
		// TODO: Fix quick healing
		/*// QUICK HEAL
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
				// NOTIFICATION LOG
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						undefined,
						"Quick healing failed, missing healing items",
						undefined,
						NOTIFICATION_TYPE.Log
					)
				);
			}
		}*/
	}
}
