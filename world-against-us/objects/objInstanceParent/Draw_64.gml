// INHERIT THE PARENT EVENT
event_inherited();
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

draw_set_font(font_small);
draw_set_halign(fa_center);
draw_set_color(c_red);

if (global.DEBUGMODE)
{
	if (!is_undefined(collider))
	{
		if (!is_undefined(collider.collision_body))
		{
			if (true || collider.collision_body.hitpoints < collider.collision_body.total_hitpoints)
			{
				WorldPositionToGUI(guiPos, x, y);
				var hpText = "Dead";
				if (collider.collision_body.state == COLLISION_BODY_STATE.ALIVE)
				{
					hpText = string(
						"{0}/{1}",
						collider.collision_body.hitpoints,
						collider.collision_body.total_hitpoints
					);
				}
				draw_text(guiPos.X, guiPos.Y + 20, hpText);
			}
		}
	}


	if (!is_undefined(skeletalAnimator))
	{
		var trackIndices = ds_map_keys_to_array(skeletalAnimator.active_animations);
		var trackCount = array_length(trackIndices);
		for (var i = 0; i < trackCount; i++)
		{
			var activeAnimation = skeletalAnimator.active_animations[? trackIndices[@ i]];
			var animationText = string("{0}: {1}", activeAnimation.animation_track, activeAnimation.animation_name);
			draw_text(guiPos.X, guiPos.Y + 40 + (20 * i), animationText);
		}
	}
}

// RESET DRAW PROPERTIES
ResetDrawProperties();