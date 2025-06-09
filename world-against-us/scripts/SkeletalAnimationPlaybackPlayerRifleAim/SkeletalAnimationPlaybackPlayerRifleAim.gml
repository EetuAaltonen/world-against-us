function SkeletalAnimationPlaybackPlayerRifleAim(_animationRef, _animatorRef)
{
	var boneData = ds_map_create();
	_animatorRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
	
	var gunDirVector = new Vector2(300, 0);
	gunDirVector.Rotate(-(boneData[? "worldAngleX"] + (90 * -(_animatorRef.instance_ref.image_xscale))));
	var gunAimLineDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], boneData[? "worldX"] - gunDirVector.X, boneData[? "worldY"] - gunDirVector.Y);
	var gunAimLineAngle = 180 - (90 * (sin(degtorad(gunAimLineDir))  + 1));
		
	var crosshairAimLineDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], mouse_x, mouse_y + 9);
	var crosshairAimLineAngle = 180 - (90 * (sin(degtorad(crosshairAimLineDir))  + 1));
	
	if (_animationRef.current_frame == 0)
	{
		// PREVENT GUN FROM FLICKERING WHEN ANIMATION STARTS PLAYING
		_animationRef.current_frame = floor(gunAimLineAngle * 2);
	} else {
		_animationRef.current_frame += (gunAimLineAngle <= crosshairAimLineAngle) ? (crosshairAimLineAngle - gunAimLineAngle) * 0.2 : -(gunAimLineAngle - crosshairAimLineAngle) * 0.2;
	}
	
	ReleaseVariableFromMemory(boneData, ds_type_map);
}