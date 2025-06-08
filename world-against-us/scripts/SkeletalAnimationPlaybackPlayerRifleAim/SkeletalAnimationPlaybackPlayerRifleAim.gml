function SkeletalAnimationPlaybackPlayerRifleAim(_animationSliceGroupRef, _animationSkeletalRef)
{
	var instanceRef = _animationSkeletalRef.instance_ref;
	var boneData = ds_map_create();
	_animationSkeletalRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
	
	var greenLineVector = new Vector2(300, 0);
	greenLineVector.Rotate(-(boneData[? "worldAngleX"] + (90 * -(_animationSliceGroupRef.instance_ref.image_xscale))));
	var dirGunline = point_direction(boneData[? "worldX"], boneData[? "worldY"], boneData[? "worldX"] - greenLineVector.X, boneData[? "worldY"] - greenLineVector.Y);
	var gunLineAngle = 180 - (90 * (sin(degtorad(dirGunline))  + 1));
		
	var aimDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], mouse_x, mouse_y + 9);
	var aimAngle = 180 - (90 * (sin(degtorad(aimDir))  + 1));
	
	_animationSliceGroupRef.current_frame += (gunLineAngle <= aimAngle) ? (aimAngle - gunLineAngle) * 0.2 : -(gunLineAngle - aimAngle) * 0.2;
	
	if (_animationSliceGroupRef.current_frame > _animationSliceGroupRef.frame_count) { _animationSliceGroupRef.current_frame = 0; }
	if (_animationSliceGroupRef.current_frame < 0) { _animationSliceGroupRef.current_frame = _animationSliceGroupRef.frame_count; }
	
	with (instanceRef)
	{
		skeleton_animation_set_frame(0, _animationSliceGroupRef.current_frame);
	}
	_animationSkeletalRef.current_frame = _animationSliceGroupRef.current_frame;
}