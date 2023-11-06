// HUD BACKGROUND
draw_sprite_ext(sprGUIBg, 0, 0, global.GUIH - hudHeight, global.GUIW, hudHeight, 0, c_black, hudAlpha);

hudElementHealth.Draw();

if (instance_exists(global.InstancePlayer))
{
	if (!is_undefined(global.InstancePlayer.character))
	{
		hudElementFullness.Draw();
		hudElementHydration.Draw();
		hudElementEnergy.Draw();
	}
	
	if (instance_exists(global.InstanceWeapon))
	{
		hudElementAmmo.Draw();
	}
}

// DRAW WORLD TIME
draw_set_font(font_date_time);
draw_set_valign(fa_middle);
draw_set_color(c_green);
var timeString = global.WorldStateHandlerRef.date_time.TimeToString();
var targetStringWidth = string_width("00:00:00");
var timeStringWidth = string_width(timeString);
var stringPositionTweak = timeStringWidth - targetStringWidth;
var timeStringPadding = 10;
draw_text(global.GUIW - timeStringWidth + stringPositionTweak - timeStringPadding, global.GUIH - (hudHeight * 0.5), timeString);

// DRAW WORLD DATE
draw_set_halign(fa_right);
var dateString = global.WorldStateHandlerRef.date_time.DateToString();
draw_text(global.GUIW - targetStringWidth - timeStringPadding - 50, global.GUIH - (hudHeight * 0.5), dateString);

// RESET DRAW PROPERTIES
ResetDrawProperties();

if (global.DEBUGMODE)
{
	if (global.GUIStateHandlerRef.IsGUIStateClosed())
	{
		if (global.HighlightHandlerRef != noone)
		{
			if (global.HighlightHandlerRef.highlightedTarget != noone)
			{
				if (instance_exists(global.HighlightHandlerRef.highlightedTarget))
				{
					var highlightedInstance = global.HighlightHandlerRef.highlightedTarget;
					if (!is_undefined(highlightedInstance.character))
					{
						var targetHUDElementLocation = new Vector2(30, 400);
						var targetHUDElementPadding = 10;
						var targetHUDElementScale = 2;
						var spriteOffset = new Vector2(
							sprite_get_xoffset(highlightedInstance.sprite_index),
							sprite_get_yoffset(highlightedInstance.sprite_index)
						);
						var spriteSize = new Size(
							sprite_get_width(highlightedInstance.sprite_index),
							sprite_get_height(highlightedInstance.sprite_index)
						);
				
						draw_sprite_ext(
							sprGUIBg, 0,
							targetHUDElementLocation.X,
							targetHUDElementLocation.Y,
							(spriteSize.w * targetHUDElementScale) + (targetHUDElementPadding * 2),
							(spriteSize.h * targetHUDElementScale) + (targetHUDElementPadding * 2),
							0, c_teal, 1
						);
				
						var spriteDrawPosition = new Vector2(
							targetHUDElementLocation.X + targetHUDElementPadding + (spriteOffset.X * targetHUDElementScale),
							targetHUDElementLocation.Y + targetHUDElementPadding + (spriteOffset.Y * targetHUDElementScale)
						);
						draw_sprite_ext(
							highlightedInstance.sprite_index,
							highlightedInstance.image_index,
							spriteDrawPosition.X,
							spriteDrawPosition.Y,
							targetHUDElementScale, targetHUDElementScale, 0, c_white, 1
						);
				
						var targetHUDBoundaryBoxLocation = new Vector2(
							targetHUDElementLocation.X + targetHUDElementPadding,
							targetHUDElementLocation.Y + targetHUDElementPadding
						);
					
						var bodyPartIndices = ds_map_keys_to_array(highlightedInstance.character.body_parts);
						var bodyPartCount = array_length(bodyPartIndices);
					
						draw_set_font(font_small_bold);
						draw_set_color(c_yellow);
					
						for (var i = 0; i < bodyPartCount; i++)
						{
							var bodyPart = highlightedInstance.character.body_parts[? bodyPartIndices[@ i]];
							var bodyPartRectangle = new Vector2Rectangle(
								new Vector2(
									targetHUDBoundaryBoxLocation.X + (spriteSize.w * bodyPart.bounding_box.top_left_point.X * targetHUDElementScale),
									targetHUDBoundaryBoxLocation.Y + (spriteSize.h * bodyPart.bounding_box.top_left_point.Y * targetHUDElementScale)
								),
								new Vector2(
									targetHUDBoundaryBoxLocation.X + (spriteSize.w * bodyPart.bounding_box.top_right_point.X * targetHUDElementScale),
									targetHUDBoundaryBoxLocation.Y + (spriteSize.h * bodyPart.bounding_box.top_right_point.Y * targetHUDElementScale)
								),
								new Vector2(
									targetHUDBoundaryBoxLocation.X + (spriteSize.w * bodyPart.bounding_box.bottom_right_point.X * targetHUDElementScale),
									targetHUDBoundaryBoxLocation.Y + (spriteSize.h * bodyPart.bounding_box.bottom_right_point.Y * targetHUDElementScale)
								),
								new Vector2(
									targetHUDBoundaryBoxLocation.X + (spriteSize.w * bodyPart.bounding_box.bottom_left_point.X * targetHUDElementScale),
									targetHUDBoundaryBoxLocation.Y + (spriteSize.h * bodyPart.bounding_box.bottom_left_point.Y * targetHUDElementScale)
								)
							);
							bodyPartRectangle.Draw(1, c_red);
						
							draw_text(
								targetHUDElementLocation.X, targetHUDElementLocation.Y - (20 * i) - 30,
								string("{0}: {1} / {2}", bodyPart.name, bodyPart.condition, bodyPart.max_condition)
							);
						}
					
						draw_text(
							targetHUDElementLocation.X, targetHUDElementLocation.Y - (20 * bodyPartCount) - 30,
							string("{0}%", highlightedInstance.character.total_hp_percent)
						);
					
						var aimLocation = new Vector2(
							targetHUDElementLocation.X + targetHUDElementPadding + (highlightedTargetCollisionPos.X * targetHUDElementScale),
							targetHUDElementLocation.Y + targetHUDElementPadding + (highlightedTargetCollisionPos.Y * targetHUDElementScale)
						);
					
						draw_sprite_ext(
							sprCrosshair,
							highlightedInstance.image_index,
							aimLocation.X,
							aimLocation.Y,
							0.2, 0.2, 0, c_red, 1
						);
					
						draw_text_color(
							targetHUDElementLocation.X, targetHUDElementLocation.Y - 15,
							string(
								"{0} : {1}",
								abs(aimLocation.X - targetHUDBoundaryBoxLocation.X) / (spriteSize.w * targetHUDElementScale),
								abs(aimLocation.Y - targetHUDBoundaryBoxLocation.Y) / (spriteSize.h * targetHUDElementScale)
							), c_yellow, c_yellow, c_yellow, c_yellow, 1
						);
					
						// RESET DRAW PROPERTIES
						ResetDrawProperties();
					}
				}
			}
		}
	}
}