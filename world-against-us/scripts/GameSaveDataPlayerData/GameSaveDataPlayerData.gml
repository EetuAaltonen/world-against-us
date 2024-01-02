function GameSaveDataPlayerData(_character, _last_location, _inventory) constructor
{
	character = _character;
	last_location = _last_location;
	inventory = _inventory;
	
	static OnDestroy = function()
	{
		character.OnDestroy();
		character = undefined;
		
		last_location.OnDestroy();
		last_location = undefined;
		
		// TODO: Fix primaryWeaponSlot, magazinePockets, and medicinePockets
		/*inventory.OnDestroy();
		inventory = undefined;*/
	}
	
	static ToJSONStruct = function()
	{
		var formatCharacterData = character.ToJSONStruct();
		var formatLastLocation = last_location.ToJSONStruct();
		// TODO: Write inventory
		//var formatInventory = inventory.ToJSONStruct();
		
		return {
			character: formatCharacterData,
			last_location: formatLastLocation,
			inventory: {}//formatInventory,
		}
	}
}