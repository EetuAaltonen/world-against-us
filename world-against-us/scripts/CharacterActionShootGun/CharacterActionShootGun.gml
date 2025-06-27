function CharacterActionShootGun(_instanceRef, _projectileSpawnPointX, _projectileSpawnPointY, _projectileSpawnPointZ, _aimPosX, _aimPosY)
{
	var actionResult = CHARACTER_ACTION_RESULT_SHOOT_GUN.SHOT;
	var primaryWeaponRef = _instanceRef.character.gear.GetItemBySlot(_instanceRef.character.gear.primary_weapon);
	if (is_undefined(primaryWeaponRef)) return CHARACTER_ACTION_RESULT_SHOOT_GUN.MISSING_GUN;
	var magazineRef = primaryWeaponRef.metadata.magazine;
	if (is_undefined(magazineRef)) return  CHARACTER_ACTION_RESULT_SHOOT_GUN.MISSING_MAGAZINE;
	var bulletsRef = magazineRef.metadata.bullets;
	if (array_length(bulletsRef) <= 0) return CHARACTER_ACTION_RESULT_SHOOT_GUN.EMPTY_MAGAZINE;
	
	// CREATE PROJECTILE INSTANCE
	var projectileInstance = instance_create_depth(
		_projectileSpawnPointX,
		_projectileSpawnPointY,
		0/*top most depth*/, objColProjectile
	);
	var aimAngle = point_direction(_projectileSpawnPointX, _projectileSpawnPointY, _aimPosX, _aimPosY);
	var bulletName = array_pop(bulletsRef);
	var bulletData = global.ItemDatabase.GetItemByName(bulletName);
	if (!is_undefined(bulletData))
	{
		// CREATE PROJECTILE
		projectileInstance.sprite_index = asset_get_index(bulletData.metadata.projectile);
		projectileInstance.direction = aimAngle;
		projectileInstance.image_angle = projectileInstance.direction;
		projectileInstance.flySpeed = bulletData.metadata.fly_speed;
		projectileInstance.damageSource = new DamageSource(
			self, bulletData, MetersToPixels(20),
			new Vector2(_projectileSpawnPointX, _projectileSpawnPointY)
		);
		projectileInstance.z = _projectileSpawnPointZ;
		
		// TODO: Fix bullet casing particles
		// BURST BULLET CASING PARTICLES
		// CALCULATE CHAMBER WORLD POSITION
		/*var primaryWeaponDataRef = _instanceRef.character.gear.primary_weapon_data;
		var chamberPos = primaryWeaponRef.metadata.chamber_pos.Clone();
		chamberPos.X -= sprite_get_xoffset(primaryWeaponRef.icon);
		chamberPos.Y -= sprite_get_yoffset(primaryWeaponRef.icon);
		chamberPos.Rotate(primaryWeaponDataRef.aim_angle * _instanceRef.image_xscale);
		var chamberWorldPos = new Vector2(
			primaryWeaponDataRef.world_position.X + (chamberPos.X * image_xscale),
			primaryWeaponDataRef.world_position.Y + (chamberPos.Y * image_yscale)
		);

		var bulletSpriteName = sprite_get_name(bulletData.icon);
		var emptyBulletSprite = asset_get_index(string("{0}{1}", bulletSpriteName, "Casing")) ?? SPRITE_ERROR;
		part_system_depth(partSystemBulletCasing, _instanceRef.depth - 1);
		part_emitter_region(
			partSystemBulletCasing, partEmitterBulletCasing,
			chamberWorldPos.X, chamberWorldPos.X,
			chamberWorldPos.Y, chamberWorldPos.Y,
			ps_shape_rectangle, ps_distr_linear
		);
		part_type_sprite(partTypeBulletCasing, emptyBulletSprite, false, false, false);
		part_type_direction(partTypeBulletCasing,
			sign(_instanceRef.image_yscale) == 1 ? 120 : 60,
			sign(_instanceRef.image_yscale) == 1 ? 140 : 40,
			0, 0
		);
		part_type_orientation(partTypeBulletCasing, image_angle - 90, image_angle - 90, sign(_instanceRef.image_yscale) * 5, false, true);
		part_emitter_burst(partSystemBulletCasing, partEmitterBulletCasing, partTypeBulletCasing, 1);*/
	}
	return actionResult;
}