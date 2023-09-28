// TODO: Implement this logic routed through NetworkHandler
/*if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	switch (packetHeader.messageType)
	{
		case MESSAGE_TYPE.DATA_PLAYER_SYNC:
		{
			var jsonString = buffer_read(networkBuffer, buffer_string);
			var allPlayerData = json_parse(jsonString);
			
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
			
			var notificationDescription = string(
				"Player syncronized\n" + 
				"Game is still in the early development state."
			);
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					sprSoldier,
					"Welcome to the Server",
					notificationDescription
				)
			);
		} break;
		case MESSAGE_TYPE.OTHER_CONNECTED_TO_HOST:
		{
			var jsonString = buffer_read(networkBuffer, buffer_string);
			var playerData = json_parse(jsonString);
			
			if (!is_undefined(playerData))
			{
				var coopPlayerObj = global.OtherPlayerData[? packetHeader.clientId];
				if (is_undefined(coopPlayerObj))
				{
					SpawnerCreatePlayerInstance(packetHeader.clientId, playerData);
				}
			}
		} break;
		case MESSAGE_TYPE.OTHER_DISCONNECT_FROM_HOST:
		{
			// DELETE DISCONNECTED PLAYER INSTANCES
			var playerObject = ds_map_find_value(global.OtherPlayerData, packetHeader.clientId);
			
			if (instance_exists(playerObject))
			{
				
				with (playerObject)
				{
					// DESTROY GUN
					instance_destroy(weapon);
					
					instance_destroy();
				}
			}
			ds_map_delete(global.OtherPlayerData, packetHeader.clientId);
		} break;
	}	
}
