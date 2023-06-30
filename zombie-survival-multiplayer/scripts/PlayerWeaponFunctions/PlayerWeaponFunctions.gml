function PlayerWeaponFunctions()
{
	// NETWORKING WEAPON FUNCTIONS
	var onWeaponUsed = false;
	var onWeaponReloaded = false;
	var magazine = primaryWeapon.metadata.magazine;
	
	// SHOOT
	if (mouse_check_button(mb_left))
	{
		if (!is_undefined(magazine))
		{
			if (magazine.metadata.GetBulletCount() > 0 && fireDelay <= 0)
			{
				UseWeapon(mouse_x, mouse_y);
				onWeaponUsed = true;
			}
		}
	}
	// RELOAD
	else if (keyboard_check_released(ord("R")))
	{
		var magazine = FetchMagazineFromPockets(primaryWeapon.metadata.caliber);
		if (!is_undefined(magazine))
		{
			InventoryReloadWeapon(primaryWeapon, magazine);
			onWeaponReloaded = true;
		} else {
			// MESSAGE LOG
			AddMessageLog(string("Reloading failed, missing magazine with {0} caliber ammo", primaryWeapon.metadata.caliber));	
		}
	}
	
	// TODO: Fix weapon functions network coding
	/*		
	// NETWORKING WEAPON FUNCTIONS
	var onWeaponUsed = false;
	var onWeaponReloaded = false;
	var bulletCount = 0; //primaryWeapon.metadata.GetBulletCount();
		
	if (primaryWeapon.metadata.GetBulletCount() > 0)
	{
		// SHOOT
		if (mouse_check_button(mb_left) && fireDelay <= 0)
		{
			UseWeapon(mouse_x, mouse_y);
			onWeaponUsed = true;
		}
	}

	// RELOAD
	if (keyboard_check_released(ord("R")))
	{
		//ReloadWeapon(primaryWeapon.metadata.capacity);
		//bulletCount = primaryWeapon.metadata.GetBulletCount();
		onWeaponReloaded = true;
	}
		
	// SEND WEAPON FUNCTIONS
	if (!is_undefined(global.ObjNetwork.client.clientId))
	{
		if (onWeaponUsed || onWeaponReloaded || isAiming != prev_is_aiming || prev_weapon_angle != image_angle)
		{
			var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.DATA_PLAYER_WEAPON_FUNCTION);
			var formatMouseX = clamp(mouse_x, 0, room_width);
			var formatMouseY = clamp(mouse_y, 0, room_height);
			var scaledMousePos = ScaleFloatValuesToIntVector2(formatMouseX, formatMouseY);
						
			buffer_write(networkBuffer, buffer_bool, onWeaponUsed);
			buffer_write(networkBuffer, buffer_u8, bulletCount);
			buffer_write(networkBuffer, buffer_bool, isAiming);
			buffer_write(networkBuffer, buffer_u32, scaledMousePos.X);
			buffer_write(networkBuffer, buffer_u32, scaledMousePos.Y);
			global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
						
			// RESET PREVIOUS VALUES
			prev_is_aiming = isAiming;
			prev_weapon_angle = image_angle;
		}
	}*/
}

function UseWeapon(_mouseX, _mouseY)
{
	var magazine = primaryWeapon.metadata.magazine;
	var bullet = array_pop(magazine.metadata.bullets);
	var projectileSpawnPoint = new Vector2(x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y);
	
	// CREATE PROJECTILE INSTANCE
	var projectileInstance = instance_create_depth(projectileSpawnPoint.X, projectileSpawnPoint.Y, 0/*top most depth*/, objProjectile);
	var aimRecoilReduction = (isAiming) ? 0.3 : 1;
	var bulletRecoil = random_range(-primaryWeapon.metadata.recoil, primaryWeapon.metadata.recoil) * aimRecoilReduction;
	var barrelAngle = point_direction(x + rotatedWeaponBarrelPos.X, y +rotatedWeaponBarrelPos.Y, _mouseX, _mouseY);
	
	projectileInstance.sprite_index = GetProjectileSpriteByBullet(bullet.name);
	projectileInstance.direction = barrelAngle + bulletRecoil;
	projectileInstance.image_angle = projectileInstance.direction;
	projectileInstance.damageSource = new DamageSource(bullet.Clone(), MetersToPixels(primaryWeapon.metadata.range), projectileSpawnPoint);
	projectileInstance.hitIgnoreInstance = objPlayer;
	
	recoilAnimation = baseRecoilAnimation;
	fireDelay = TimerRatePerMinute(primaryWeapon.metadata.fire_rate);
	muzzleFlashTimer = muzzleFlashTime;
}

function InitializeWeapon()
{
	sprite_index = primaryWeapon.icon;
	fireDelay = 0;
	recoilAnimation = 0;
	muzzleFlashTimer = 0;
	global.ObjHud.hudElementMagazine.InitMagazine();
}

function CalculateBarrelPos()
{
	var xOrigin = sprite_get_xoffset(sprite_index);
	var yOrigin = sprite_get_yoffset(sprite_index);
	var barrelPos = new Vector2(
		(primaryWeapon.metadata.barrel_pos.X - xOrigin) * image_xscale,
		(primaryWeapon.metadata.barrel_pos.Y - yOrigin) * image_yscale
	);
	rotatedWeaponBarrelPos = RotateVector2(barrelPos, image_angle);
}