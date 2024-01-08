function GameSaveData(_player_data/*, _game_state_data*/) constructor
{
	player_data = _player_data;
	// TODO: Game state data
	//game_state_data = _game_state_data;
	
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
	
	static InitNewSave = function()
	{
		var initCharacter = new GameSaveDataCharacter(EMPTY_STRING, undefined);
		var initPosition = new Vector2(0, 0);
		var initLastLocation = new GameSaveDataLastLocation(initPosition, ROOM_DEFAULT);
		player_data = new GameSaveDataPlayerData(initCharacter, initLastLocation, undefined);
		//game_state_data;
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