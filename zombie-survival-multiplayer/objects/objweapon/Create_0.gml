// INHERIT THE PARENT EVENT
event_inherited();

owner = noone;
spriteScale = 0.8;
image_speed = 0;
image_xscale = spriteScale;
image_yscale = spriteScale;

primaryWeapon = undefined;
isAiming = false;
rotatedWeaponBarrelPos = undefined;
initWeapon = false;
weaponYOffset = 10;

muzzleFlashTime = 2; // FRAMES
muzzleFlashTimer = 0;
fireDelay = 0;
baseRecoilAnimation = 8;
recoilAnimation = 0;

// NETWORKING VALUE MONITORING
weapon_aim_pos = new Vector2(x, y);
prev_is_aiming = isAiming;
prev_weapon_angle = image_angle;