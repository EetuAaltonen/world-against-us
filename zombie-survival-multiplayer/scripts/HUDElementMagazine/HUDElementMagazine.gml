function HUDElementMagazine(_position) : HUDElement(_position) constructor
{
	size = new Size(100, 0);
	weapon_reference = undefined;
	bullet_animations = [];
	bullet_animations_step = 0.05;
	prev_bullet_count = 0;
	
	static SetWeaponReference = function(_weaponReference)
	{
		weapon_reference = _weaponReference;
	}
	
	static InitMagazine = function()
	{
		if (!is_undefined(weapon_reference))
		{
			if (!is_undefined(weapon_reference.primaryWeapon))
			{
				if (!is_undefined(weapon_reference.primaryWeapon.metadata.magazine))
				{
					var magazine = weapon_reference.primaryWeapon.metadata.magazine;
					var bulletCount = magazine.metadata.GetBulletCount();
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
	
	static Update = function()
	{
		if (!is_undefined(weapon_reference))
		{
			if (!is_undefined(weapon_reference.primaryWeapon))
			{
				if (!is_undefined(weapon_reference.primaryWeapon.metadata.magazine))
				{
					var magazine = weapon_reference.primaryWeapon.metadata.magazine;
					var bulletCount = magazine.metadata.GetBulletCount();
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
	
	static Draw = function()
	{
		if (global.GUIStateHandlerRef.IsGUIStateClosed())
		{
			if (!is_undefined(weapon_reference))
			{
				if (!is_undefined(weapon_reference.primaryWeapon))
				{
					if (!is_undefined(weapon_reference.primaryWeapon.metadata.magazine))
					{
						var magazine = weapon_reference.primaryWeapon.metadata.magazine;
						var bulletMargin = 10;
						var magazinePadding = 20;
						var bgHeightWithCapacity = bulletMargin * magazine.metadata.capacity + (magazinePadding * 2);
						
						// DRAW MAGAZINE BACKGROUND
						draw_sprite_ext(sprGUIBg, 0, position.X, position.Y - bgHeightWithCapacity, size.w, bgHeightWithCapacity, 0, c_black, 1);
						
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
				}
			}
		}
	}
}