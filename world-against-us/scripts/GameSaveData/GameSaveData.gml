function GameSaveData(_player_data/*, _game_state_data*/) constructor
{
	player_data = _player_data;
	
	static ToJSONStruct = function()
	{
		var formatPlayerData = player_data.ToJSONStruct();
		return {
			player_data: formatPlayerData	
		}
	}
	
	static OnDestroy = function()
	{
		player_data.OnDestroy();
		player_data = undefined;
	}
	
	static FetchSaveData = function()
	{
		var isSaveDataFetched = true;
		// FETCH CHARACTER
		player_data.character.name = global.PlayerCharacter.name;
		player_data.character.backpack = global.PlayerCharacter.GetBackpackSlotItem();
		
		// FETCH LAST POSITION
		player_data.last_location.position.X = global.InstancePlayer.x;
		player_data.last_location.position.Y = global.InstancePlayer.y;
		
		return isSaveDataFetched;
	}
}