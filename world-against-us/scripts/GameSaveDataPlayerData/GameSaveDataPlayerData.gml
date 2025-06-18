function GameSaveDataPlayerData(_character, _last_location) constructor
{
	character = _character;
	last_location = _last_location;
	
	static ToJSONStruct = function()
	{
		var formatCharacterData = character.ToJSONStruct();
		var formatLastLocation = last_location.ToJSONStruct();
		
		return {
			character: formatCharacterData,
			last_location: formatLastLocation,
		}
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.character);
		_struct.character = undefined;
		
		ReleaseVariableFromMemory(_struct.last_location);
		_struct.last_location = undefined;
	}
}