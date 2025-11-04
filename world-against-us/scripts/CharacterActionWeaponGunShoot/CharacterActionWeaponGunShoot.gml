function CharacterActionWeaponGunShoot(_instanceRef, _aimPosX, _aimPosY)
{
	var actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.SHOT;
	var primaryWeaponRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.primary_weapon);
	if (is_undefined(primaryWeaponRef)) return CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.MISSING_GUN;
	var magazineRef = primaryWeaponRef.metadata.magazine;
	if (is_undefined(magazineRef)) return  CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.MISSING_MAGAZINE;
	var bulletsRef = magazineRef.metadata.bullets;
	if (array_length(bulletsRef) <= 0) return CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.EMPTY_MAGAZINE;
	var bulletName = array_first(bulletsRef);
	var bulletData = global.ItemDatabase.GetItemByName(bulletName);
	if (is_undefined(bulletData)) return CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.EMPTY_MAGAZINE;
	
	// SET CHARACTER ACTION COOLDOWN
	var fireRateDelayInMilliseconds = time_bpm_to_seconds(primaryWeaponRef.metadata.fire_rate) * 1000;
	var activeAction = new CharacterActiveAction(
		_instanceRef, CHARACTER_ACTION.SHOOT,
		undefined, 1, fireRateDelayInMilliseconds, false, false
	);
	if (_instanceRef.character.action_handler.SetAction(activeAction))
	{
		// CALCULATE BARREL WORLD POSITION
		var primaryWeaponDataRef = _instanceRef.character.gear.primary_weapon_data;
		var barrelWorldPos = primaryWeaponRef.metadata.barrel_pos.Clone();
		barrelWorldPos.X -= sprite_get_xoffset(primaryWeaponRef.icon);
		barrelWorldPos.Y -= sprite_get_yoffset(primaryWeaponRef.icon);
		barrelWorldPos.Rotate(primaryWeaponDataRef.aim_angle * _instanceRef.image_xscale);
		var primaryWeaponBarrelPos = new Vector2(
			primaryWeaponDataRef.world_position.X + (barrelWorldPos.X * _instanceRef.image_xscale),
			primaryWeaponDataRef.world_position.Y + (barrelWorldPos.Y * _instanceRef.image_yscale)
		);
			
		// CREATE PROJECTILE INSTANCE
		var projectileSpawnPointX = primaryWeaponBarrelPos.X + abs(primaryWeaponDataRef.barrel_to_ground_offset.X);
		var projectileSpawnPointY = primaryWeaponBarrelPos .Y + abs(primaryWeaponDataRef.barrel_to_ground_offset.Y);
		var projectileSpawnPointZ = abs(primaryWeaponDataRef.barrel_to_ground_offset.Y);
		var aimAngle = point_direction(
			projectileSpawnPointX, projectileSpawnPointY,
			_aimPosX, _aimPosY + abs(primaryWeaponDataRef.barrel_to_ground_offset.Y)
		);
		var projectileInstance = instance_create_depth(
			projectileSpawnPointX,
			projectileSpawnPointY,
			-_instanceRef.y, objProjectile
		);
		projectileInstance.sprite_index = asset_get_index(bulletData.metadata.projectile);
		projectileInstance.direction = aimAngle;
		projectileInstance.image_angle = projectileInstance.direction;
		projectileInstance.flySpeed = bulletData.metadata.fly_speed;
		projectileInstance.damageSource = new DamageSource(
			self, bulletData, MetersToPixels(20),
			new Vector2(projectileSpawnPointX, projectileSpawnPointY)
		);
		projectileInstance.z = projectileSpawnPointZ;
	
		// REMOVE BULLET FROM MAGAZINE
		array_pop(bulletsRef);
	
		// CALCULATE CHAMBER WORLD POSITION
		var primaryWeaponDataRef = _instanceRef.character.gear.primary_weapon_data;
		var chamberPos = primaryWeaponRef.metadata.chamber_pos.Clone();
		chamberPos.X -= sprite_get_xoffset(primaryWeaponRef.icon);
		chamberPos.Y -= sprite_get_yoffset(primaryWeaponRef.icon);
		chamberPos.Rotate(primaryWeaponDataRef.aim_angle * _instanceRef.image_xscale);
		var chamberWorldPos = new Vector2(
			primaryWeaponDataRef.world_position.X + (chamberPos.X * image_xscale),
			primaryWeaponDataRef.world_position.Y + (chamberPos.Y * image_yscale)
		);
	
		// BURST BULLET CASING PARTICLES
		var bulletSpriteName = sprite_get_name(bulletData.icon);
		var emptyBulletSprite = asset_get_index(string("{0}{1}", bulletSpriteName, "Casing")) ?? SPRITE_ERROR;
		part_system_depth(
			primaryWeaponDataRef.partSystemBulletCasing,
			-_instanceRef.y - 1
		);
		part_emitter_region(
			primaryWeaponDataRef.partSystemBulletCasing, primaryWeaponDataRef.partEmitterBulletCasing,
			chamberWorldPos.X, chamberWorldPos.X,
			chamberWorldPos.Y, chamberWorldPos.Y,
			ps_shape_rectangle, ps_distr_linear
		);
		part_type_sprite(
			primaryWeaponDataRef.partTypeBulletCasing,
			emptyBulletSprite,
			false, false, false
		);
		part_type_direction(primaryWeaponDataRef.partTypeBulletCasing,
			aimAngle + (140 * sign(_instanceRef.image_xscale)),
			aimAngle + (170 * sign(_instanceRef.image_xscale)),
			0, 0
		);
		part_type_orientation(
			primaryWeaponDataRef.partTypeBulletCasing,
			aimAngle,
			aimAngle,
			sign(_instanceRef.image_xscale) * 5,
			false, true
		);
		part_emitter_burst(
			primaryWeaponDataRef.partSystemBulletCasing,
			primaryWeaponDataRef.partEmitterBulletCasing,
			primaryWeaponDataRef.partTypeBulletCasing, 1
		);
	} else {
		actionResult = CHARACTER_ACTION_RESULT_WEAPON_GUN_SHOOT.ACTION_FAILED;
	}
	return actionResult;
}