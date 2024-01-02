function PlayerDataHandler() constructor
{
	character = new CharacterHuman("Player", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.PLAYER);
	last_known_location = undefined;
	primaryWeaponSlot = new Inventory("PlayerPrimaryWeaponSlot", INVENTORY_TYPE.PlayerPrimaryWeaponSlot, new InventorySize(4, 6), new InventoryFilter([], ["Weapon"], []));
	magazinePockets = new Inventory("PlayerMagazinePocket", INVENTORY_TYPE.MagazinePockets, new InventorySize(4, 2), new InventoryFilter([], ["Magazine", "Bullet", "Fuel Ammo"], []));
	medicinePockets = new Inventory("PlayerMedicinePocket", INVENTORY_TYPE.MedicinePockets, new InventorySize(4, 2), new InventoryFilter([], ["Medicine"], []));
	
	static OnDestroy = function()
	{
		character.OnDestroy();
		character = undefined;
		primaryWeaponSlot.OnDestroy();
		primaryWeaponSlot = undefined;
		magazinePockets.OnDestroy();
		magazinePockets = undefined;
		medicinePockets.OnDestroy();
		medicinePockets = undefined;
	}
	
	static LoadPlayerData = function(gameSaveData)
	{
		var isPlayerDataLoaded = false;
		if (!is_undefined(gameSaveData))
		{
			var gameSaveDataPlayerData = gameSaveData.player_data;
			if (!is_undefined(gameSaveDataPlayerData))
			{
				// TODO: Fetch all character data
				var gameSaveCharacter = gameSaveDataPlayerData.character;
				if (!is_undefined(gameSaveCharacter))
				{
					var gameSaveBackpack = gameSaveCharacter.backpack;
					if (!is_undefined(gameSaveBackpack))
					{
						// FETCH BACKPACK FROM GAME SAVE DATA
						character.backpack_slot.AddItem(gameSaveBackpack, undefined, false, true);
					} else {
						// ADD STARTING SUPPLIES
						var backpack = global.ItemDatabase.GetItemByName("Hiking Backpack");
						if (!is_undefined(backpack))
						{
							backpack.metadata.InitInventory(string("{0}Backpack", character.name), INVENTORY_TYPE.PlayerBackpack);
							character.backpack_slot.AddItem(backpack, undefined, false, true);
							backpack.metadata.inventory.AddMultipleItems([
								global.ItemDatabase.GetItemByName("Watering Can"),
								global.ItemDatabase.GetItemByName("Garden Tools"),
								global.ItemDatabase.GetItemByName("Fertilizer Sack"),
								global.ItemDatabase.GetItemByName("Tomato Seed Pack")
							]);
						}
					}
					isPlayerDataLoaded = true;
				}
				
				// SET GLOBAL VARIABLES
				global.PlayerBackpack = character.GetBackpackInventory();
				global.PlayerPrimaryWeaponSlot = primaryWeaponSlot;
				global.PlayerMagazinePockets = magazinePockets;
				global.PlayerMedicinePockets = medicinePockets;
			}
		}
		return isPlayerDataLoaded;
	}
}