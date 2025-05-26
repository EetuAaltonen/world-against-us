// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index) return;

if (global.DEBUGMODE)
{
	if (!is_undefined(collider))
	{
		if (!is_undefined(collider.collision_body))
		{
			if (collider.collision_body.state == COLLISION_BODY_STATE.ALIVE)
			{
				if (!is_undefined(character))
				{
					draw_circle_color(
						x, y, character.vision_radius,
						c_orange, c_orange, true
					);
				}
	
				if (!is_undefined(aiBase))
				{
					draw_circle_color(
						aiBase.wander_origin_pos.X, aiBase.wander_origin_pos.Y, aiBase.wander_radius,
						c_purple, c_purple, true
					);
		
					if (!is_undefined(aiBase.target_position))
					{
						draw_line_width_color(
							x, y, aiBase.target_position.X, aiBase.target_position.Y,
							2, c_white, c_white
						)
					}
		
					// DRAW PATH TO TARGET
					if (!is_undefined(aiBase.path_to_target))
					{
						if (path_exists(path_index))
						{
							aiBase.path_to_target.Draw(path_position);
						}
					}
				}
			}
		}
	}
}