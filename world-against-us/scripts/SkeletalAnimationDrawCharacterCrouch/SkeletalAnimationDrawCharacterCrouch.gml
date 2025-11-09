function SkeletalAnimationDrawCharacterCrouch(_animationRef, _animatorRef)
{
	SkeletalAnimationDraw(_animationRef, _animatorRef);
	
	var instanceRef = _animatorRef.instance_ref;
	var instanceDirSpeed = _animatorRef.instance_ref.dirSpeed;
	var boneData = ds_map_create();
	
	// PREVENT WEAPON FROM FLICKERING WHEN IMAGE XSCALE CHANGES
	if (!instanceDirSpeed.has_turned)
	{
		_animatorRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
		var weaponAngle = -(boneData[? "worldAngleX"] + 90);
		var imageIndex = (instanceRef.character.gear.has_primary_weapon_magazine) ? 0 : 1;
		draw_sprite_ext(
			sprAk47, imageIndex,
			boneData[? "worldX"],
			boneData[? "worldY"],
			instanceRef.image_xscale, instanceRef.image_yscale,
			weaponAngle, c_white, 1
		);
	}
	
	ReleaseVariableFromMemory(boneData, ds_type_map);
}