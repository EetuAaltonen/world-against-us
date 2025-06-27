function GetLocalPlayerInputAction()
{
	// SHOOT WEAPON
	if (mouse_check_button_pressed(mb_left))
	{
		var primaryWeaponRef = character.gear.GetItemBySlot(character.gear.primary_weapon);
		if (!is_undefined(primaryWeaponRef))
		{
			// CALCULATE BARREL WORLD POSITION
			var primaryWeaponDataRef = character.gear.primary_weapon_data;
			var barrelWorldPos = primaryWeaponRef.metadata.barrel_pos.Clone();
			barrelWorldPos.X -= sprite_get_xoffset(primaryWeaponRef.icon);
			barrelWorldPos.Y -= sprite_get_yoffset(primaryWeaponRef.icon);
			barrelWorldPos.Rotate(primaryWeaponDataRef.aim_angle * image_xscale);
			var primaryWeaponBarrelPos = new Vector2(
				primaryWeaponDataRef.world_position.X + (barrelWorldPos.X * image_xscale),
				primaryWeaponDataRef.world_position.Y + (barrelWorldPos.Y * image_yscale)
			);
			
			// CHARACTER ACTION SHOOT GUN
			var projectileSpawnPointX = primaryWeaponBarrelPos.X + abs(primaryWeaponDataRef.barrel_to_ground_offset.X);
			var projectileSpawnPointY = primaryWeaponBarrelPos .Y + abs(primaryWeaponDataRef.barrel_to_ground_offset.Y);
			var actionResult = CharacterActionShootGun(
				self,
				projectileSpawnPointX,
				projectileSpawnPointY,
				abs(primaryWeaponDataRef.barrel_to_ground_offset.Y),
				mouse_x, mouse_y + abs(primaryWeaponDataRef.barrel_to_ground_offset.Y)
			);
		}
	} else if (keyboard_check_released(ord("R")))
	{
		var actionResult = CharacterActionReloadGun(self);
		if (actionResult == CHARACTER_ACTION_RESULT_RELOAD_GUN.RELOADED)
		{
			if (skeletalAnimator.GetActiveAnimationNameByTrack(0) != "rifle_reload")
			{
				skeletalAnimator.SetActiveAnimation("rifle_reload", 0, "upperbody", 1, false, true);
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
