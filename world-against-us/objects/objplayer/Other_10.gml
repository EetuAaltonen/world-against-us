/// @description Custom RoomStartEvent
var gameSaveData = global.GameSaveHandlerRef.game_save_data;
if (!is_undefined(gameSaveData))
{
	if (gameSaveData.isSaveLoadingFirstTime)
	{
		// TODO: Parse character from game save data
		character = new CharacterHuman("Player", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.PLAYER);
		
		var savePlayerData = gameSaveData.player_data;
		if (!is_undefined(savePlayerData))
		{
			var saveDataBackpack = (!is_undefined(gameSaveData.player_data.character)) ? gameSaveData.player_data.character.backpack : undefined;
			if (!is_undefined(saveDataBackpack))
			{
				character.backpack_slot.AddItem(saveDataBackpack, undefined, false, true, true);
				if (!is_undefined(saveDataBackpack.metadata))
				{
					global.PlayerBackpack = saveDataBackpack.metadata.inventory;
				}
			} else {
				var backpack = global.ItemDatabase.GetItemByName("Hiking Backpack");
				if (!is_undefined(backpack))
				{
					backpack.metadata.InitInventory(string("{0}Backpack", character.name), INVENTORY_TYPE.PlayerBackpack);
					character.backpack_slot.AddItem(backpack, undefined, false, true, true);
					
					// ADD SOME STARTING SUPPLIES
					backpack.metadata.inventory.AddMultipleItems([
						global.ItemDatabase.GetItemByName("Watering Can"),
						global.ItemDatabase.GetItemByName("Garden Tools"),
						global.ItemDatabase.GetItemByName("Fertilizer Sack"),
						global.ItemDatabase.GetItemByName("Tomato Seed Pack")
					]);
				
					global.PlayerBackpack = backpack.metadata.inventory;
				}
			}
		}

		global.PlayerCharacter = character;
	} else {
		character = global.PlayerCharacter;
	}
}

// NETWORKING
syncTimer.StartTimer();