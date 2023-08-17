// INHERIT THE PARENT EVENT
event_inherited();

owner = noone;
spriteScale = 1;
image_speed = 0;
image_xscale = spriteScale;
image_yscale = spriteScale;

primaryWeapon = undefined;
isAiming = false;
rotatedWeaponOffset = new Vector2(0, 0);
rotatedWeaponBarrelPos = undefined;
rotatedWeaponChamberPos = undefined;
initWeapon = false;

muzzleFlashTime = 2; // FRAMES
muzzleFlashTimer = 0;
fireDelay = 0;
kickbackAnimation = 0;

// NETWORKING VALUE MONITORING
weapon_aim_pos = new Vector2(x, y);
prev_is_aiming = isAiming;
prev_weapon_angle = image_angle;

// EMPTY BULLET CASING PARTICLES
partSystemBulletCasing = part_system_create();
partEmitterBulletCasing = part_emitter_create(partSystemBulletCasing);
partTypeBulletCasing = part_type_create();
InitializeParticleBulletCasing(partTypeBulletCasing);