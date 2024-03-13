function PlayerDataHandler() constructor
{
	// TODO: Editable player name for singleplayer
	player_name = (global.MultiplayerMode) ? global.NetworkHandlerRef.player_tag : "Player";
	character = undefined;
	last_known_location = undefined;
	// TODO: Low casing property names
	primaryWeaponSlot = undefined;
	magazinePockets = undefined;
	medicinePockets = undefined;
	
	// TODO: Typo in variable name
	positionSyncTImer = new Timer(500);
	
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
	
	static OnRoomStart = function()
	{
		// NETWORKING
		if (global.MultiplayerMode)
		{
			// START POSITION SYNC TIMER
			positionSyncTImer.StartTimer();
		}
		
		if (!is_undefined(character))
		{
			// RESTORE PLAYER CHARACTER STATE TO NORMAL
			if (character.IsInvulnerableState())
			{
				if (room_get_name(room) == ROOM_INDEX_CAMP)
				{
					// DELETE ALL ITEMS AFTER BEING ROBBED
					// AND SAVE LOCAL GAME
					if (character.is_robbed)
					{
						// DELETE ALL ITEMS
						global.PlayerBackpack.ClearAllItems();
				
						character.RestoreState();
				
						// SAVE 
						global.GameSaveHandlerRef.SaveGame();
					}
				}
				character.RestoreState();
			}
		}
	}
	
	static Update = function()
	{
		if (global.MultiplayerMode)
		{
			if (instance_exists(global.InstancePlayer))
			{
				positionSyncTImer.Update();
				var playerInstance = global.InstancePlayer;
				if (instance_exists(playerInstance))
				{
					if ((playerInstance.x != playerInstance.previousPosition.X) || (playerInstance.y != playerInstance.previousPosition.Y))
					{
						if (positionSyncTImer.IsTimerStopped())
						{
							var formatPosition = ScaleFloatValuesToIntVector2(playerInstance.x, playerInstance.y);
							var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PLAYER_DATA_POSITION);
							var networkPacket = new NetworkPacket(
								networkPacketHeader,
								formatPosition,
								PACKET_PRIORITY.DEFAULT,
								undefined
							);
							if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
							{
								// TODO: Generic error handling
								show_debug_message("Unable to queue MESSAGE_TYPE.PLAYER_DATA_POSITION");
							}
							// UPDATE PREVIOUS POSITION
							playerInstance.previousPosition.X = playerInstance.x;
							playerInstance.previousPosition.Y = playerInstance.y;
				
							// RESET TIMER
							positionSyncTImer.StartTimer();
						}
					}
				
					// UPDATE PLAYER MOVEMENT INPUT
					var movementInput = playerInstance.movementInput;
					var prevMovementInput = playerInstance.prevMovementInput;
					if (movementInput.key_up != prevMovementInput.key_up ||
						movementInput.key_down != prevMovementInput.key_down ||
						movementInput.key_left != prevMovementInput.key_left ||
						movementInput.key_right != prevMovementInput.key_right)
					{
						var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT);
						var networkPacket = new NetworkPacket(
							networkPacketHeader,
							movementInput,
							PACKET_PRIORITY.DEFAULT,
							undefined
						);
						if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
						{
							// TODO: Generic error handling
							show_debug_message("Unable to queue MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT");
						}
					
						prevMovementInput.key_up = movementInput.key_up;
						prevMovementInput.key_down = movementInput.key_down;
						prevMovementInput.key_left = movementInput.key_left;
						prevMovementInput.key_right = movementInput.key_right;
					}
				}
			}
		}
	}
	
	static InitPlayerData = function()
	{
		if (!is_undefined(character))
		{
			OnDestroy();
		}
		
		character = new CharacterHuman(player_name, CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOR.PLAYER);
		last_known_location = undefined;
		primaryWeaponSlot = new Inventory("PlayerPrimaryWeaponSlot", INVENTORY_TYPE.PlayerPrimaryWeaponSlot, new InventorySize(4, 6), new InventoryFilter([], ["Weapon"], []));
		magazinePockets = new Inventory("PlayerMagazinePocket", INVENTORY_TYPE.MagazinePockets, new InventorySize(4, 2), new InventoryFilter([], ["Magazine", "Bullet", "Fuel Ammo"], []));
		medicinePockets = new Inventory("PlayerMedicinePocket", INVENTORY_TYPE.MedicinePockets, new InventorySize(4, 2), new InventoryFilter([], ["Medicine"], []));
	}
	
	static LoadPlayerData = function()
	{
		var isPlayerDataLoaded = false;
		var gameSaveData = global.GameSaveHandlerRef.game_save_data;
		if (!is_undefined(gameSaveData))
		{
			if (gameSaveData != EMPTY_SAVE_DATA)
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
							isPlayerDataLoaded = true;
						}
					}
				}
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
						global.ItemDatabase.GetItemByName("Tomato Seed Pack", 10)
					]);
				}
				isPlayerDataLoaded = true;
			}
			
			// SET GLOBAL VARIABLES
			global.PlayerBackpack = character.GetBackpackInventory();
			global.PlayerPrimaryWeaponSlot = primaryWeaponSlot;
			global.PlayerMagazinePockets = magazinePockets;
			global.PlayerMedicinePockets = medicinePockets;
		}
		return isPlayerDataLoaded;
	}
	
	static OnRobbed = function()
	{
		if (!is_undefined(character))
		{
			// SET PLAYER BEING ROBBED
			character.is_robbed = true;
		}
		
		var playerInstance = global.InstancePlayer;
		if (instance_exists(playerInstance))
		{
			// RESET DEVICE INPUT MOVEMENT
			// THIS ALSO TRIGGERS PLAYER TO STOP ON REMOTE CLIENTS' VIEW
			playerInstance.movementInput.Reset();
		}
		
		// OPEN GAME OVER WINDOW
		var guiState = new GUIState(
			GUI_STATE.GameOver, undefined, undefined,
			[
				CreateWindowGameOver(GAME_WINDOW.GameOver, -1)
			],
			GUI_CHAIN_RULE.OverwriteAll,
			undefined, undefined
		);
		global.GUIStateHandlerRef.RequestGUIState(guiState);
	}
}