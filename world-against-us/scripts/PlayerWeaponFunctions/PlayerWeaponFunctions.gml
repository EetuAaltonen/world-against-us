function PlayerWeaponFunctions()
{
	// NETWORKING WEAPON FUNCTIONS
	var onWeaponUsed = false;
	var onWeaponReloaded = false;
	
	// SHOOT
	if (mouse_check_button(mb_left))
	{
		if (primaryWeapon.metadata.GetAmmoCount() > 0 && fireDelay <= 0)
		{
			var mouseWorldPosition = MouseWorldPosition();
			UseWeapon(mouseWorldPosition);
			onWeaponUsed = true;
		}
	}
	// RELOAD
	else if (keyboard_check_released(ord("R")))
	{
		if (primaryWeapon.type != "Melee")
		{
			switch (primaryWeapon.metadata.chamber_type)
			{
				case "Shell":
				{
					var shellCountToReload = primaryWeapon.metadata.GetAmmoCapacity() - primaryWeapon.metadata.GetAmmoCount();
					var shellStacks = FetchAmmoPocketShellStacks(primaryWeapon, shellCountToReload);
					var shellStackCount = array_length(shellStacks);
					for (var i = 0; i < shellStackCount; i++)
					{
						var shellStack = shellStacks[@ i];
						if (!is_undefined(shellStack))
						{
							if (InventoryReloadWeaponShotgun(primaryWeapon, shellStack))
							{
								shellStack.sourceInventory.RemoveItemByGridIndex(shellStack.grid_index);
								onWeaponReloaded = true;
							}
						}
					}
					
					if (shellStackCount <= 0)
					{
						// LOG NOTIFICATION
						global.NotificationHandlerRef.AddNotification(
							new Notification(
								undefined,
								string("Reloading failed, missing ammo for {0}", primaryWeapon.name),
								undefined,
								NOTIFICATION_TYPE.Log
							)
						);
					}
				} break;
				case "Fuel Tank":
				{
					var fuelTank = FetchAmmoPocketFuelTank(primaryWeapon);
					if (!is_undefined(fuelTank))
					{
						// SWAP FUEL TANKS WITH ROLLBACK
						fuelTank.sourceInventory.RemoveItemByGridIndex(fuelTank.grid_index);
						if (InventoryReloadWeaponFlamethrower(primaryWeapon, fuelTank))
						{
							onWeaponReloaded = true;
						} else {
							fuelTank.sourceInventory.AddItem(fuelTank, fuelTank.grid_index, fuelTank.is_rotated, fuelTank.is_known);
						}
					} else {
						// LOG NOTIFICATION
						global.NotificationHandlerRef.AddNotification(
							new Notification(
								undefined,
								string("Reloading failed, missing ammo for {0}", primaryWeapon.name),
								undefined,
								NOTIFICATION_TYPE.Log
							)
						);
					}
				} break;
				default:
				{
					var magazine = FetchAmmoPocketMagazine(primaryWeapon);
					if (!is_undefined(magazine))
					{
						// SWAP MAGAZINES WITH ROLLBACK
						magazine.sourceInventory.RemoveItemByGridIndex(magazine.grid_index);
						if (InventoryReloadWeaponGun(primaryWeapon, magazine))
						{
							onWeaponReloaded = true;
						} else {
							magazine.sourceInventory.AddItem(magazine, magazine.grid_index, magazine.is_rotated, magazine.is_known);
						}
					} else {
						// LOG NOTIFICATION
						global.NotificationHandlerRef.AddNotification(
							new Notification(
								undefined,
								string("Reloading failed, missing ammo for {0}", primaryWeapon.name),
								undefined,
								NOTIFICATION_TYPE.Log
							)
						);
					}
				}
			}
			
			// UPDATE HUD ELEMENT FOR AMMO
			global.ObjHud.hudElementAmmo.initAmmo = true;
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

function UseWeapon(_mouseWorldPosition)
{
	if (primaryWeapon.type != "Melee")
	{
		var projectileSpawnPoint = new Vector2(x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y);
		
		switch (primaryWeapon.metadata.chamber_type)
		{
			case "Fuel Tank":
			{
				var fuelTank = primaryWeapon.metadata.fuel_tank;
				if (!is_undefined(fuelTank))
				{
					var flame = global.ItemDatabase.GetItemByName("Flamethrower Flame");
					if (!is_undefined(flame))
					{
						WeaponSpawnProjectile(
							flame, projectileSpawnPoint, _mouseWorldPosition,
							primaryWeapon.metadata.recoil, isAiming,
							random_range(0.5, 1), irandom_range(0, 359)
						);
						fuelTank.metadata.fuel_level--;
					}
				}
			} break;
			default:
			{
				if (primaryWeapon.metadata.chamber_type == "Magazine")
				{
					var magazine = primaryWeapon.metadata.magazine;
					if (!is_undefined(magazine))
					{
						var bullet = array_pop(magazine.metadata.bullets);
						if (!is_undefined(bullet))
						{
							WeaponSpawnProjectile(bullet, projectileSpawnPoint, _mouseWorldPosition, primaryWeapon.metadata.recoil, isAiming);
							
							// CREATE EMPTY SHELL PARTICLE
							CreateWeaponBulletEmptyParticle(self, rotatedWeaponChamberPos, bullet.icon);
						}
					}
				} else if (primaryWeapon.metadata.chamber_type == "Shell")
				{
					var bullet = array_pop(primaryWeapon.metadata.shells);
					if (!is_undefined(bullet))
					{
						repeat (5)
						{
							WeaponSpawnProjectile(bullet, projectileSpawnPoint, _mouseWorldPosition, primaryWeapon.metadata.recoil, isAiming);
						}
						
						// CREATE EMPTY SHELL PARTICLE
						CreateWeaponBulletEmptyParticle(self, rotatedWeaponChamberPos, bullet.icon);
					}
					
				} else {
					throw ("Invalid weapon chamber_type to shoot")	
				}
			}
		}
	}
	
	kickbackAnimation = primaryWeapon.metadata.kickback;
	fireDelay = (60000 / primaryWeapon.metadata.fire_rate);
	muzzleFlashTimer = muzzleFlashTime;
}

function CreateWeaponBulletEmptyParticle(_weaponInstance, _rotatedWeaponChamberPos, _bulletIcon)
{
	// BURST BULLET CASING PARTICLES
	if (!is_undefined(_rotatedWeaponChamberPos))
	{
		var bulletSpriteName = sprite_get_name(_bulletIcon);
		var emptyBulletSprite = asset_get_index(string("{0}{1}", bulletSpriteName, "Casing")) ?? SPRITE_ERROR;

		part_system_depth(partSystemBulletCasing, _weaponInstance.depth - 1);
		part_emitter_region(
			partSystemBulletCasing, partEmitterBulletCasing,
			_weaponInstance.x + _rotatedWeaponChamberPos.X,
			_weaponInstance.x + _rotatedWeaponChamberPos.X,
			_weaponInstance.y + _rotatedWeaponChamberPos.Y,
			_weaponInstance.y + _rotatedWeaponChamberPos.Y,
			ps_shape_rectangle,
			ps_distr_linear
		);
		part_type_sprite(partTypeBulletCasing, emptyBulletSprite, false, false, false);
		part_type_direction(partTypeBulletCasing,
			sign(_weaponInstance.image_yscale) == 1 ? 120 : 60,
			sign(_weaponInstance.image_yscale) == 1 ? 140 : 40,
			0, 0
		);
		part_type_orientation(partTypeBulletCasing, image_angle - 90, image_angle - 90, sign(_weaponInstance.image_yscale) * 5, false, true);
		part_emitter_burst(partSystemBulletCasing, partEmitterBulletCasing, partTypeBulletCasing, 1);
	}	
}

function WeaponSpawnProjectile(_bullet, _spawnPoint, _mouseWorldPosition, _recoil, _isAiming, _scale = 1, _rotation = undefined)
{
	// CREATE PROJECTILE INSTANCE
	var projectileInstance = instance_create_depth(_spawnPoint.X, _spawnPoint.Y, 0/*top most depth*/, objProjectile);
	var aimRecoilReduction = (_isAiming) ? 0.3 : 1;
	var bulletRecoil = random_range(-_recoil, _recoil) * aimRecoilReduction;
	var barrelAngle = point_direction(x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y, _mouseWorldPosition.X, _mouseWorldPosition.Y);
	
	var aimAngleVectorLine = new Vector2Line(
		_spawnPoint,
		_mouseWorldPosition
	);
	var aimAngleDirectionVector = new Vector2(
		aimAngleVectorLine.end_point.X - aimAngleVectorLine.start_point.X,
		aimAngleVectorLine.end_point.Y - aimAngleVectorLine.start_point.Y,
	);
	aimAngleDirectionVector = RotateVector2(aimAngleDirectionVector, bulletRecoil);
	aimAngleVectorLine.end_point.X = aimAngleVectorLine.start_point.X + aimAngleDirectionVector.X;
	aimAngleVectorLine.end_point.Y = aimAngleVectorLine.start_point.Y + aimAngleDirectionVector.Y;
	projectileInstance.aimAngleLine = aimAngleVectorLine;
	
	projectileInstance.sprite_index = GetSpriteByName(_bullet.metadata.projectile);
	projectileInstance.flySpeed = _bullet.metadata.fly_speed;
	projectileInstance.direction = barrelAngle + bulletRecoil;
	projectileInstance.image_angle = _rotation ?? projectileInstance.direction;
	projectileInstance.image_xscale = _scale;
	projectileInstance.image_yscale = projectileInstance.image_xscale;
	projectileInstance.damageSource = new DamageSource(_bullet.Clone(), MetersToPixels(primaryWeapon.metadata.range), _spawnPoint);
	projectileInstance.hitIgnoreInstance = objPlayer; // HITBOX OWNER OBJECT INDEX
}

function InitializeWeapon()
{
	sprite_index = primaryWeapon.icon;
	fireDelay = 0;
	kickbackAnimation = 0;
	muzzleFlashTimer = 0;
	global.ObjHud.hudElementAmmo.initAmmo = true;
}

function CalculateBarrelPos()
{
	var xOrigin = sprite_get_xoffset(sprite_index);
	var yOrigin = sprite_get_yoffset(sprite_index);
	var barrelPos = new Vector2(
		(primaryWeapon.metadata.barrel_pos.X - xOrigin) * image_xscale,
		(primaryWeapon.metadata.barrel_pos.Y - yOrigin) * image_yscale
	);
	rotatedWeaponBarrelPos = barrelPos.Rotate(image_angle);
}

function CalculateChamberPos()
{
	var xOrigin = sprite_get_xoffset(sprite_index);
	var yOrigin = sprite_get_yoffset(sprite_index);
	var barrelPos = new Vector2(
		(primaryWeapon.metadata.chamber_pos.X - xOrigin) * image_xscale,
		(primaryWeapon.metadata.chamber_pos.Y - yOrigin) * image_yscale
	);
	rotatedWeaponChamberPos = barrelPos.Rotate(image_angle);
}

function CalculateHandPosition(_handPosition)
{
	var xOrigin = sprite_get_xoffset(sprite_index);
	var yOrigin = sprite_get_yoffset(sprite_index);
	var handPosition = new Vector2(
		(_handPosition.X - xOrigin) * image_xscale,
		(_handPosition.Y - yOrigin) * image_yscale
	);
	handPosition = handPosition.Rotate(image_angle);
	
	return handPosition;
}