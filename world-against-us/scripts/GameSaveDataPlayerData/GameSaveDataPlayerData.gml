function GameSaveDataPlayerData(_character, _last_location) constructor
{
	character = _character;
	last_location = _last_location;
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(character);
		character = undefined;
		
		ReleaseVariableFromMemory(last_location);
		last_location = undefined;
	}
	
	static ToJSONStruct = function()
	{
		var formatCharacterData = character.ToJSONStruct();
		var formatLastLocation = last_location.ToJSONStruct();
		
		return {
			character: formatCharacterData,
			last_location: formatLastLocation,
		}
	}
}