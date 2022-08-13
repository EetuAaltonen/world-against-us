if (async_load[? "size"] > 0)
{
	// Set latency
	latency = latencyTimer;
	latencyTimer = 0;
	isLatencyTimerRunning = false;
	
	var buffer = async_load[? "buffer"];
	buffer_seek(buffer, buffer_seek_start, 0);
	
	var response = buffer_read(buffer, buffer_string);
	
	var jsonStruct = json_parse(response);
	var content = jsonStruct[$ "content"];
	switch (jsonStruct[$ "message_type"])
	{
		case MESSAGE_TYPE.CONNECT_TO_HOST:
		{
			var contentItem = content[@ 0];
			if (contentItem[$ "key"] == "client_id")
			{
				client.SetClientId(contentItem[$ "value"]);
			}
		} break;
		case MESSAGE_TYPE.LATENCY:
		{
			latency = latencyTimer;
			latencyTimer = 0;
		} break;
		case MESSAGE_TYPE.DATA:
		{
			var contentSize = array_length(content);
			for (var i = 0; i < contentSize; i++)
			{
				var contentData = content[@ i];
				switch (contentData[$ "key"])
				{
					case "all_player_data":
					{
						var allPlayerData = contentData[$ "value"];
						if (!is_undefined(allPlayerData))
						{
							var playerCount = array_length(allPlayerData);
							for (var i = 0; i < playerCount; i++)
							{
								var playerData = allPlayerData[@ i];
								var playerUuid = playerData[$ "uuid"];
								if (playerUuid != client.clientId)
								{
									var position = playerData[$ "position"];
									var coopPlayerObj = global.CoopPlayers[? playerUuid];
									if (is_undefined(coopPlayerObj))
									{
										var coopPlayer = instance_create_layer(position[$ "x"], position[$ "y"], "Player", objPlayer);
										coopPlayer.character = new Character(playerUuid, CHARACTER_TYPE.COOP_PLAYER);
										coopPlayer.image_index = 1;
										ds_map_add(global.CoopPlayers, playerUuid, coopPlayer);
									} else {
										if (instance_exists(coopPlayerObj))
										{
											with (coopPlayerObj)
											{
												targetLocation = new Vector2(position[$ "x"], position[$ "y"]);
											}
										}
									}
								}
							}
						}
					} break;
				}
			}
		} break;
		case MESSAGE_TYPE.DISCONNECT:
		{
			
		} break;
	}
}
