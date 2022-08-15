function SpawnerCreatePlayerInstance(_playerUuid, _playerData)
{
	var coopPlayerObj = instance_create_layer(0, 0, "Player", objPlayer);
	coopPlayerObj.character = new Character(_playerUuid, CHARACTER_TYPE.COOP_PLAYER);
	coopPlayerObj.character.uuid = _playerUuid;
	coopPlayerObj.image_index = 1;

	var position = _playerData[$ "position"];
	var vectorSpeed = _playerData[$ "vector_speed"];
	var inputMap = _playerData[$ "input_map"];
							
	with (coopPlayerObj)
	{
		x = position[$ "x"];
		y = position[$ "y"];
		hSpeed = vectorSpeed[$ "x"];
		vSpeed = vectorSpeed[$ "y"];
								
		key_up = inputMap[$ "key_up"];
		key_down = inputMap[$ "key_down"];
		key_left = inputMap[$ "key_left"];
		key_right = inputMap[$ "key_right"];
	}
						
	ds_map_add(global.OtherPlayerData, _playerUuid, coopPlayerObj);
}