function HUDElementAmmo(_position) : HUDElement(_position) constructor
{
	size = new Size(100, 0);
	weapon_reference = undefined;
	bullet_animations = [];
	bullet_animations_step = 0.05;
	prev_bullet_count = 0;
	
	initAmmo = true;
	
	static SetWeaponReference = function(_weaponReference)
	{
		weapon_reference = _weaponReference;
	}
	
	static InitAmmo = function()
	{
		bullet_animations = [];
		
		if (!is_undefined(weapon_reference))
		{
			if (!is_undefined(weapon_reference.primaryWeapon))
			{
				if (weapon_reference.primaryWeapon.type != "Melee")
				{
					switch (weapon_reference.primaryWeapon.metadata.chamber_type)
					{
						case "Shell":
						{
							var bulletCount = weapon_reference.primaryWeapon.metadata.GetAmmoCount();
							bullet_animations = [];
							for (var i = 0; i < bulletCount; i++)
							{
								array_push(bullet_animations, new HUDBulletAnimation(weapon_reference.primaryWeapon.metadata.shells[i].icon, new Vector2(100, 100), -180));
							}
							prev_bullet_count = bulletCount;
						} break;
						default:
						{
							if (!is_undefined(weapon_reference.primaryWeapon.metadata.magazine))
							{
								var magazine = weapon_reference.primaryWeapon.metadata.magazine;
								var bulletCount = magazine.metadata.GetAmmoCount();
								bullet_animations = [];
								for (var i = 0; i < bulletCount; i++)
								{
									array_push(bullet_animations, new HUDBulletAnimation(magazine.metadata.bullets[i].icon, new Vector2(100, 100), -180));
								}
								prev_bullet_count = bulletCount;
							}
						}
					}
				}
			}
		}
	}
	
	static Update = function()
	{
		if (initAmmo)
		{
			initAmmo = false;
			InitAmmo();
		} else {
			if (!is_undefined(weapon_reference))
			{
				if (!is_undefined(weapon_reference.primaryWeapon))
				{
					if (weapon_reference.primaryWeapon.type != "Melee")
					{
						if (weapon_reference.primaryWeapon.metadata.chamber_type == "Magazine" ||
							weapon_reference.primaryWeapon.metadata.chamber_type == "Shell")
						{
							var bulletCount = weapon_reference.primaryWeapon.metadata.GetAmmoCount();
							if (bulletCount < prev_bullet_count)
							{
								var animationCount = array_length(bullet_animations);
								bullet_animations[@ bulletCount].animation_step = 0;
								prev_bullet_count = bulletCount;
							}
					
							var animationCount = array_length(bullet_animations);
							if (animationCount > 0)
							{
								for (var i = 0; i < animationCount; i++)
								{
									var animationStep = bullet_animations[@ i];
									if (animationStep.animation_step >= 0 && animationStep.animation_step < 1)
									{
										animationStep.animation_step += bullet_animations_step;
									} else if (animationStep.animation_step >= 1)
									{
										// REMOVE ELEMENT WHEN ANIMATION ENDS
										array_pop(bullet_animations);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	static Draw = function()
	{
		if (global.GUIStateHandlerRef.IsGUIStateClosed())
		{
			if (!is_undefined(weapon_reference))
			{
				if (!is_undefined(weapon_reference.primaryWeapon))
				{
					if (weapon_reference.primaryWeapon.type != "Melee")
					{
						switch (weapon_reference.primaryWeapon.metadata.chamber_type)
						{
							case "Fuel Tank":
							{
								DrawFuelLevel();
							} break;
							default:
							{
								DrawBullets();
							}
						}
					}
				}
			}
		}
	}
	
	static DrawBullets = function()
	{
		var bulletMargin = 10;
		var magazinePadding = 20;
		var bgHeightWithCapacity = bulletMargin * weapon_reference.primaryWeapon.metadata.GetAmmoCapacity() + (magazinePadding * 2);
						
		// DRAW AMMO BACKGROUND
		draw_sprite_ext(sprGUIBg, 0, position.X, position.Y - bgHeightWithCapacity, size.w, bgHeightWithCapacity, 0, c_dkgray, 1);
						
		// DRAW BULLETS
		var bulletAnimationCount = array_length(bullet_animations);
		var bulletXOffset = size.w * 0.5;
						
		for (var i = 0; i < bulletAnimationCount; i++)
		{
			var bulletSprite = bullet_animations[@ i].icon;
			var bulletScale = ScaleSpriteToFitSize(bulletSprite, new Size(undefined, bulletMargin));
			var bulletAnimation = bullet_animations[@ i];
							
			if (bulletAnimation.animation_step < 0)
			{
				draw_sprite_ext(
					bulletSprite, 0,
					position.X + bulletXOffset, position.Y - (bulletMargin * i) - magazinePadding,
					-bulletScale, bulletScale, 0, c_white, 1
				);
			} else {
				draw_sprite_ext(
					bulletSprite, 0,
					position.X + (bulletAnimation.end_position.X * bulletAnimation.animation_step) + bulletXOffset,
					position.Y - (bulletMargin * i) - (bulletAnimation.end_position.Y * bulletAnimation.animation_step) - magazinePadding,
					-bulletScale, bulletScale, bulletAnimation.end_rotation * bulletAnimation.animation_step, c_white, 1
				);
			}
		}
	}
	
	static DrawFuelLevel = function()
	{
		var bgHeight = 400;
		var fuelLevelPadding = 20;
		var fuelLevel = weapon_reference.primaryWeapon.metadata.GetAmmoCapacity() > 0 ? CeilToTwoDecimals(weapon_reference.primaryWeapon.metadata.GetAmmoCount() / weapon_reference.primaryWeapon.metadata.GetAmmoCapacity()) : 0;
		
		// DRAW FUEL BACKGROUND
		draw_sprite_ext(
			sprGUIBg, 0,
			position.X, position.Y - bgHeight,
			size.w, bgHeight, 0, c_dkgray, 1
		);
		
		// DRAW FUEL LEVEL
		draw_sprite_ext(
			sprGUIBg, 0,
			position.X + fuelLevelPadding, position.Y - fuelLevelPadding,
			size.w - (fuelLevelPadding * 2), -((bgHeight * fuelLevel) - (fuelLevelPadding * 2 * sign(fuelLevel))),
			0, c_green, 1
		);
		
		draw_set_font(font_small_bold);
		draw_set_halign(fa_center);
		draw_text_color(
			position.X + (size.w * 0.5), position.Y - 20,
			string("{0}%", fuelLevel * 100),
			c_white, c_white, c_white, c_white, 1
		);
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}