if (character.type == CHARACTER_TYPE.PLAYER)
{
	if (!is_undefined(global.ObjNetwork.client.routinePacket))
	{
		if (global.ObjNetwork.client.tickTimer == 1)
		{
			if (x != prev_x || y != prev_y) global.ObjNetwork.client.routinePacket.AddContent("player_position", new Vector2(x, y));
			if (hSpeed != prev_hspeed || vSpeed != prev_vspeed) global.ObjNetwork.client.routinePacket.AddContent("player_vector_speed", new Vector2(hSpeed, vSpeed));
			
			// RESET PREVIOUS VALUES
			ResetPlayerMovementValues();
		}
	}
	
	if (!is_undefined(global.ObjNetwork.client.importantPacket))
	{
		var inputMap = [];
		if (key_up != prev_key_up) array_push(inputMap, new InputKey("key_up", key_up));
		if (key_down != prev_key_down) array_push(inputMap, new InputKey("key_down", key_down));
		if (key_left != prev_key_left) array_push(inputMap, new InputKey("key_left", key_left));
		if (key_right != prev_key_right) array_push(inputMap, new InputKey("key_right", key_right));
		
		if (array_length(inputMap) > 0)
		{
			global.ObjNetwork.client.importantPacket.AddContent("player_input", inputMap);
		}
		
		// RESET PREVIOUS VALUES
		ResetPlayerInputValues();
	}
}
