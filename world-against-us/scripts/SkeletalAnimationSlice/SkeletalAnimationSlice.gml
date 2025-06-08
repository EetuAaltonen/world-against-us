function SkeletalAnimationSlice(_instanceRef, _animEvents, _animSliceGroups) : SkeletalAnimation(_instanceRef, _animEvents) constructor
{
	animation_slice_groups = _animSliceGroups;
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(animation_slice_groups, ds_type_list);
		animation_slice_groups = undefined;
	}
	
	static Draw = function()
	{
		// OVERRIDE PARENT FUNCTION
		CheckActiveAnimationEventFrames(ev_draw);
		
		var sliceGroupCount = ds_list_size(animation_slice_groups);
		for (var i = 0; i < sliceGroupCount; i++)
		{
			var sliceGroup = animation_slice_groups[| i];
			if (!is_undefined(sliceGroup))
			{
				sliceGroup.playback_function(sliceGroup, self);
				draw_skeleton(
					instance_ref.sprite_index, sliceGroup.animation_name, sliceGroup.animation_skin_name,
					sliceGroup.current_frame, instance_ref.x, instance_ref.y - instance_ref.z, 
					instance_ref.image_xscale, instance_ref.image_yscale,
					instance_ref.image_angle, c_orange, instance_ref.image_alpha
				);
			}
		}
	}
	
	static DrawEnd = function()
	{
		var boneData = ds_map_create();
		animation_skeleton.GetBoneDataByName("b_weapon_slot", boneData);
		draw_sprite_ext(
			sprAk47_test, 0, boneData[? "worldX"], boneData[? "worldY"],
			instance_ref.image_xscale, instance_ref.image_yscale,
			-(boneData[? "worldAngleX"] + 90), c_white, 1
		);
		
		if (global.DEBUGMODE)
		{
			draw_set_font(font_tiny_bold);
			draw_set_halign(fa_center);
			draw_set_color(c_red);
			
			var greenLineVector = new Vector2(300, 0);
			greenLineVector.Rotate(-(boneData[? "worldAngleX"] + (90 * -(instance_ref.image_xscale))));
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
			draw_text(global.ObjMouse.aimPos.X, global.ObjMouse.aimPos.Y + 100, string("Frame: {0}", current_frame));
		
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		
			ReleaseVariableFromMemory(boneData, ds_type_map);
		}
	}
}