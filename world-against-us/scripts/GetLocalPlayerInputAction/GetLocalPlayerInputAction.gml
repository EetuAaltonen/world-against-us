function GetLocalPlayerInputAction()
{
	// ACTIONS THAT DON'T INTERUPT OTHER ACTIONS
	var actionHandlerRef = character.action_handler;
	if (is_undefined(actionHandlerRef.active_action))
	{
		// SHOOT WEAPON
		if (mouse_check_button(mb_left))
		{
			if (!actionHandlerRef.IsActionInCooldown(CHARACTER_ACTION.SHOOT))
			{
				var actionResult = CharacterActionWeaponGunShoot(self, mouse_x, mouse_y);
			}
		} else if (keyboard_check_released(ord("R")))
		{
			if (!actionHandlerRef.IsActionInCooldown(CHARACTER_ACTION.RELOAD))
			{
				var actionResult = CharacterActionWeaponGunReload(self);
				if (actionResult == CHARACTER_ACTION_RESULT_WEAPON_GUN_RELOAD.RELOADED)
				{
					if (skeletalAnimator.GetActiveAnimationNameByTrack(0) != "rifle_reload")
					{
						skeletalAnimator.SetActiveAnimation("rifle_reload", 0, "upperbody", 1, false, true);
					}
				}
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
