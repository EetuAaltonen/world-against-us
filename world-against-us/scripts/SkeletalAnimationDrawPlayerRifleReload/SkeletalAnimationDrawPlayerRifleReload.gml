function SkeletalAnimationDrawPlayerRifleReload(_animationRef, _animatorRef)
{
	SkeletalAnimationDraw(_animationRef, _animatorRef);
	
	var instanceRef = _animatorRef.instance_ref;
	var instanceDirSpeed = _animatorRef.instance_ref.dirSpeed;
	var boneData = ds_map_create();
	
	var weaponImageIndex = 0;
	switch (_animationRef.animation_event_state)
	{
		case "ev_rifle_mag_detach":
		{
			weaponImageIndex = 1;
			
			// PREVENT MAGAZINE FROM FLICKERING WHEN IMAGE XSCALE CHANGES
			if (!instanceDirSpeed.has_turned)
			{
				_animatorRef.animation_skeleton.GetBoneDataByName("b_secondary_weapon_slot", boneData);
				var magazineAngle = -(boneData[? "worldAngleX"] + 90);
				draw_sprite_ext(
					sprAk47Mag, 0,
					boneData[? "worldX"] + instanceDirSpeed.h_speed,
					boneData[? "worldY"] + instanceDirSpeed.v_speed,
					0.45 * -instanceRef.image_xscale, 0.45 * instanceRef.image_yscale,
					magazineAngle, c_white, 1
				);
			}
		} break;
		case "ev_rifle_mag_attach":
		{
			_animationRef.animation_event_state = undefined;
		} break;
	}
	

	// PREVENT WEAPON FROM FLICKERING WHEN IMAGE XSCALE CHANGES
	if (!instanceDirSpeed.has_turned)
	{
		_animatorRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
		var weaponAngle = -(boneData[? "worldAngleX"] + 90);
		draw_sprite_ext(
			sprAk47, weaponImageIndex,
			boneData[? "worldX"] + instanceDirSpeed.h_speed,
			boneData[? "worldY"] + instanceDirSpeed.v_speed,
			instanceRef.image_xscale, instanceRef.image_yscale,
			weaponAngle, c_white, 1
		);
	}
	
	ReleaseVariableFromMemory(boneData, ds_type_map);
}