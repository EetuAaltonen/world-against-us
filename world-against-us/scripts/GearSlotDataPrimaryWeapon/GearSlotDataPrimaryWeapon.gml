function GearSlotDataPrimaryWeapon() constructor
{
	world_position = new Vector2(-1, -1);
	barrel_to_ground_offset = new Vector2(0, -88);
	aim_angle = 0;
	has_ammo = false;
	is_holstered = false;
	
	muzzleFlashTimer = new Timer((1000 / 60) * 2); // 2 FRAMES
	fireDelay = 0;
	kickbackAnimation = 0;
	// EMPTY BULLET CASING PARTICLES
	partSystemBulletCasing = part_system_create();
	partEmitterBulletCasing = part_emitter_create(partSystemBulletCasing);
	partTypeBulletCasing = part_type_create();
	InitializeParticleBulletCasing(partTypeBulletCasing);
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.world_position);
		_struct.world_position = undefined;
		ReleaseVariableFromMemory(_struct.barrel_to_ground_offset);
		_struct.barrel_to_ground_offset = undefined;
	}
}