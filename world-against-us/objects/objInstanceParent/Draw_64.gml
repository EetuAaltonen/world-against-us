// INHERIT THE PARENT EVENT
event_inherited();
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

draw_set_font(font_small);
draw_set_halign(fa_center);
draw_set_color(c_red);

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
			draw_text(guiPos.X, guiPos.Y + 40, collider.collision_body.state);
		}
	}
}

if (global.DEBUGMODE)
{
	if (!is_undefined(skeletalAnimation))
	{
		var animName = skeletalAnimation.GetActiveAnimationName();
		var animFrame = skeletalAnimation.current_frame;
		var animFrameCount = skeletalAnimation.frame_count;
		var animDuration = skeletalAnimation.GetActiveAnimationDuration();
		WorldPositionToGUI(guiPos, x, y);
		var animText = string(
			"{0}: {1} / {2} ({3}) | {4} ms",
			animName, animFrame, animFrameCount, image_number, animDuration
		);
		draw_text(guiPos.X, guiPos.Y + 60, animText);
	}
	draw_text(guiPos.X, guiPos.Y + 90, string("{0} / {1}", dirSpeed.hSpeed, dirSpeed.vSpeed));
}

// RESET DRAW PROPERTIES
ResetDrawProperties();