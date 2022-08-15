if (async_load[? "size"] > 0)
{	
	var data = DecodeBuffer(async_load[? "buffer"]);
	var clientId = data[$ "client_id"];
	var content = data[$ "content"];
	switch (data[$ "message_type"])
	{
		case MESSAGE_TYPE.CONNECT_TO_HOST:
		{
			var allPlayerData = GetContentValueByKey(content, "all_player_data");
			if (!is_undefined(allPlayerData))
			{
				var playerUuids = variable_struct_get_names(allPlayerData);
				var playerCount = array_length(playerUuids);
				for (var i = 0; i < playerCount; i++) {
					var playerUuid = playerUuids[i];
				    var playerData = allPlayerData[$ playerUuid];
					
					if (playerUuid != global.ObjNetwork.client.clientId)
					{	
						var coopPlayerObj = global.OtherPlayerData[? playerUuid];
						if (is_undefined(coopPlayerObj))
						{
							SpawnerCreatePlayerInstance(playerUuid, playerData);
						}
					}
				}
			}
		} break;
		case MESSAGE_TYPE.OTHER_CONNECTED_TO_HOST:
		{
			var playerData = GetContentValueByKey(content, "player_data");
			show_debug_message(string(playerData));
			if (!is_undefined(playerData))
			{
				var coopPlayerObj = global.OtherPlayerData[? clientId];
				if (is_undefined(coopPlayerObj))
				{
					SpawnerCreatePlayerInstance(clientId, playerData);
				}
			}
		} break;
		case MESSAGE_TYPE.OTHER_DISCONNECT_FROM_HOST:
		{
			// DELETE DISCONNECTED PLAYER INSTANCES
			var playerObject = ds_map_find_value(global.OtherPlayerData, clientId);
				
			if (instance_exists(playerObject))
			{
					with (playerObject)
					{
						instance_destroy();
					}
			}
			ds_map_delete(global.OtherPlayerData, clientId);
		} break;
	}
}
