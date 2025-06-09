function SkeletalAnimationDrawPlayerRifleAim(_animationRef, _animatorRef)
{
	SkeletalAnimationDraw(_animationRef, _animatorRef);
	
	var instanceRef = _animatorRef.instance_ref;
	var boneData = ds_map_create();
	_animatorRef.animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
	var instanceDirSpeed = _animatorRef.instance_ref.dirSpeed;
	var weaponAngle = -(boneData[? "worldAngleX"] + 90);
	

	// PREVENT WEAPON FROM FLICKERING WHEN IMAGE XSCALE CHANGES
	if (!instanceDirSpeed.has_turned)
	{
		draw_sprite_ext(
			sprAk47, 0,
			boneData[? "worldX"] + instanceDirSpeed.h_speed,
			boneData[? "worldY"] + instanceDirSpeed.v_speed,
			instanceRef.image_xscale, instanceRef.image_yscale,
			weaponAngle, c_white, 1
		);
	}
	
	if (global.DEBUGMODE)
	{
		draw_set_font(font_tiny_bold);
		draw_set_halign(fa_center);
		draw_set_color(c_red);
		
		var greenLineVector = new Vector2(300, 0);
		var greenLineAngle = -(boneData[? "worldAngleX"] + (90 * (instanceDirSpeed.has_turned ? instanceRef.image_xscale : -(instanceRef.image_xscale))));
		greenLineVector.Rotate(greenLineAngle);
		draw_line_width_color(
			boneData[? "worldX"], boneData[? "worldY"],
			boneData[? "worldX"] - greenLineVector.X, boneData[? "worldY"] - greenLineVector.Y,
			2, c_lime, c_lime
		);
		draw_circle_color(mouse_x, mouse_y + 9, 2, c_red, c_red, false);
		var dirGunline = point_direction(boneData[? "worldX"], boneData[? "worldY"], boneData[? "worldX"] - greenLineVector.X, boneData[? "worldY"] - greenLineVector.Y);
		var gunLineAngle = 180 - (90 * (sin(degtorad(dirGunline))  + 1));
		draw_text(global.ObjMouse.aimPos.X, global.ObjMouse.aimPos.Y + 20, string("Gun line: {0}*", gunLineAngle));
		
		var aimDir = point_direction(boneData[? "worldX"], boneData[? "worldY"], mouse_x, mouse_y);
		var aimAngle = 180 - (90 * (sin(degtorad(aimDir))  + 1));
		draw_text(global.ObjMouse.aimPos.X, global.ObjMouse.aimPos.Y + 40, string("Gun to aim: {0}*", aimAngle));
		draw_line_width_color(
			boneData[? "worldX"], boneData[? "worldY"],
			mouse_x, mouse_y, 
			2, c_blue, c_blue
		);
		
		draw_text(global.ObjMouse.aimPos.X, global.ObjMouse.aimPos.Y + 60, string("Bone: {0} / {1}*", boneData[? "worldAngleX"], boneData[? "worldAngleY"]));
		draw_text(global.ObjMouse.aimPos.X, global.ObjMouse.aimPos.Y + 100, string("Frame: {0}", _animationRef.current_frame));
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
	ReleaseVariableFromMemory(boneData, ds_type_map);
}