function SpawnerCreatePlayerInstance(_playerUuid, _playerData)
{
	var position = _playerData[$ "position"];
	var scaledPosition = ScaleIntValuesToFloatVector2(position[$ "x"], position[$ "y"]);
	var vectorSpeed = _playerData[$ "vector_speed"];
	var inputMap = _playerData[$ "input_map"];
	var primaryWeapon = _playerData[$ "primary_weapon"];
	
	var coopPlayerObj = instance_create_depth(scaledPosition.X, scaledPosition.Y, depth, objPlayer);
	coopPlayerObj.character = new Character(_playerUuid, CHARACTER_TYPE.COOP_PLAYER, CHARACTER_RACE.humanoid);
	coopPlayerObj.character.uuid = _playerUuid;
	coopPlayerObj.image_index = 1;
	
	// PRIMARY WEAPON
	var primaryWeapon = ParseJSONStructToItem(primaryWeapon);
	
	with (coopPlayerObj)
	{
		hSpeed = vectorSpeed[$ "x"];
		vSpeed = vectorSpeed[$ "y"];
								
		key_up = inputMap[$ "key_up"];
		key_down = inputMap[$ "key_down"];
		key_left = inputMap[$ "key_left"];
		key_right = inputMap[$ "key_right"];
		
		if (!is_undefined(primaryWeapon))
		{
			weapon.primaryWeapon = ParseJSONStructToItem(primaryWeapon);
			weapon.initWeapon = true;
		}
	}
						
	ds_map_add(global.OtherPlayerData, _playerUuid, coopPlayerObj);
}