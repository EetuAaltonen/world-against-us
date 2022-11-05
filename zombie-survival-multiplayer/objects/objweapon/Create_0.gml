owner = noone;
spriteScale = 0.8;
image_xscale = spriteScale;
image_yscale = spriteScale;

primaryWeapon = undefined;
isAiming = false;
rotatedWeaponBarrelPos = undefined;
initWeapon = false;
weaponYOffset = 10;

fireDelay = 0;
recoilAnimation = 0;

bulletAnimations = array_create(0, -1);
bulletAnimationStep = 0.05;

// NETWORKING VALUE MONITORING
weapon_aim_pos = new Vector2(x, y);
prev_is_aiming = isAiming;
prev_weapon_angle = image_angle;