if (muzzleFlashTimer > 0)
{
	draw_sprite_ext(
		sprMuzzleFlash, 0,
		x + rotatedWeaponBarrelPos.X, y + rotatedWeaponBarrelPos.Y,
		image_xscale, image_yscale,
		image_angle, c_white, 1
	);
}

if (isInCameraView && sprite_index != -1) draw_self();