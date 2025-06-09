function SkeletalAnimationPlaybackPlayerRifleAim(_animationRef, _animatorRef)
{
	var boneData = ds_map_create();
	_animatorRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
	
	var greenLineVector = new Vector2(300, 0);
	greenLineVector.Rotate(-(boneData[? "worldAngleX"] + (90 * -(_animatorRef.instance_ref.image_xscale))));
	var dirGunline = point_direction(boneData[? "worldX"], boneData[? "worldY"], boneData[? "worldX"] - greenLineVector.X, boneData[? "worldY"] - greenLineVector.Y);
	var gunLineAngle = 180 - (90 * (sin(degtorad(dirGunline))  + 1));
		
	var aimDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], mouse_x, mouse_y + 9);
	var aimAngle = 180 - (90 * (sin(degtorad(aimDir))  + 1));
	
	_animationRef.current_frame += (gunLineAngle <= aimAngle) ? (aimAngle - gunLineAngle) * 0.2 : -(gunLineAngle - aimAngle) * 0.2;
	
	ReleaseVariableFromMemory(boneData, ds_type_map);
}