if (async_load[? "size"] > 0)
{
	if (character.type == CHARACTER_TYPE.COOP_PLAYER)
	{
		var data = DecodeBuffer(async_load[? "buffer"]);
		var clientId = data[$ "client_id"];
		var content = data[$ "content"];
		
		if (!is_undefined(clientId))
		{
			if (character.uuid == clientId)
			{
				switch (data[$ "message_type"])
				{
					case MESSAGE_TYPE.DATA:
					{
						var contentSize = array_length(content);
						for (var i = 0; i < contentSize; i++)
						{
							var valueKeyPair = content[@ i];
							switch (valueKeyPair[$ "key"])
							{
								case "player_position":
								{
									var position = valueKeyPair[$ "value"];
							
									x = position[$ "x"];
									y = position[$ "y"];
								} break;
								case "player_vector_speed":
								{
									var vectorSpeed = valueKeyPair[$ "value"];
							
									hSpeed = vectorSpeed[$ "x"];
									vSpeed = vectorSpeed[$ "y"];
								} break;
								case "player_input":
								{
									var inputMap = valueKeyPair[$ "value"];
									GetRemotePlayerMovementInput(inputMap);
								} break;
							}
						}
					} break;
				}
			}
		}
	}
}
