function GameSaveDataCharacter(_name, _backpack) constructor
{
	name = _name;
	backpack = _backpack;
	
	static OnDestroy = function()
	{
		backpack.OnDestroy();
		backpack = undefined;
	}
	
	static ToJSONStruct = function()
	{
		var formatBackpack = backpack.ToJSONStruct();
		return {
			name: name,
			backpack: formatBackpack
		}
	}
}