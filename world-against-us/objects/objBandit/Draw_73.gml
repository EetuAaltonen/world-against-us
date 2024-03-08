// DEBUG TARGET PATH
if (global.DEBUGMODE)
{
	var instanceOriginPosition = GetInstanceOriginPosition(self);
	
	if (!is_undefined(character))
	{
		// TODO: Use instance origin position instead of x and y
		// DRAW VISION RADIUS
		draw_circle_color(instanceOriginPosition.X, instanceOriginPosition.Y, character.vision_radius, c_purple, c_purple, true);
		
		// DRAW CLOSE RANGE RADIUS
		draw_circle_color(instanceOriginPosition.X, instanceOriginPosition.Y, character.close_range_radius, c_red, c_red, true);
	}
	
	if (!is_undefined(aiBandit))
	{
		switch (aiBandit.GetStateIndex())
		{
			case AI_STATE_BANDIT.PATROL:
			{
				// DRAW PATROL PATH
				if (!is_undefined(aiBandit.patrol.route))
				{
					aiBandit.patrol.route.Draw();
				}
			} break;
			case AI_STATE_BANDIT.PATROL_END:
			{
				// NO MORE PATHING
			} break;
			default:
			{
				// DRAW PATH TO TARGET
				if (!is_undefined(aiBandit.path_to_target))
				{
					aiBandit.path_to_target.Draw();
					
					// DRAW PATH UPDATE THRESHOLD
					var pathEndPoint = aiBandit.path_to_target.GetPathPoint(1);
					if (!is_undefined(pathEndPoint))
					{
						draw_circle_color(
							pathEndPoint.X, pathEndPoint.Y,
							aiBandit.path_update_threshold,
							c_red, c_red, true
						);
					}
				}
			}
		}
		
		// DRAW PATH BLOCKING RADIUS
		draw_circle_color(instanceOriginPosition.X, instanceOriginPosition.Y, aiBandit.path_blocking_radius, c_silver, c_silver, true);
		
		// DRAW PATROL STATE
		draw_set_halign(fa_center);
		draw_text_color(
			x + 20, bbox_bottom + 20,
			string(aiBandit.GetStateIndex()),
			c_orange, c_orange,
			c_orange, c_orange, 1
		);
		
		// DRAW TARGET INSTANCE
		draw_text_color(
			x + 20, bbox_bottom + 50,
			string("target_instance: {0}", instance_exists(aiBandit.target_instance)),
			c_orange, c_orange,
			c_orange, c_orange, 1
		);
		
		// DRAW TARGET POSITION
		var targetPosition = aiBandit.target_position;
		if (!is_undefined(targetPosition))
		{
			draw_text_color(
				x + 20, bbox_bottom + 80,
				string("target_position: {0}-{1}", targetPosition.X, targetPosition.Y),
				c_orange, c_orange,
				c_orange, c_orange, 1
			);
		}
		
		// DRAW PATROL ROUTE PROGRESS
		draw_text_color(
			x + 20, bbox_bottom + 140,
			string("patrol.route_progress (x1000): {0}", aiBandit.patrol.route_progress * 1000),
			c_orange, c_orange,
			c_orange, c_orange, 1
		);
	}
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}
