// LOAD CONTROLLERS TO A ROOM
var controllerCount = array_length(controllers);

show_debug_message(EMPTY_STRING);
show_debug_message(string("**Loading controllers for '{0}'**", room_get_name(room)));

// RESET DEBUGMODE ON ROOM START
global.DEBUGMODE = false;

for (var i = 0; i < controllerCount; i++)
{
	var controller = controllers[@ i];
	
	if (instance_exists(controller.objectIndex))
	{
		// DESTROY IF CONTROLLER SHOULD BE DEACTIVE
		if (ArrayContainsValue(controller.deactiveRooms, room))
		{
			controller.RemoveInstance();
			instance_destroy(controller.objectIndex);
			continue;
		}
		
		// DESTROY IF CONTROLLER IS NOT IN RESTRICTED ROOM
		if (array_length(controller.restrictedRooms) > 0)
		{
			if (!ArrayContainsValue(controller.restrictedRooms, room))
			{
				controller.RemoveInstance();
				instance_destroy(controller.objectIndex);
				continue;
			}
		}
	} else {
		// SKIP IF CONTROLLER SHOULD BE DEACTIVE
		if (ArrayContainsValue(controller.deactiveRooms, room))
		{
			continue;
		}
		// SKIP IF CONTROLLER IS NOT IN RESTRICTED ROOM
		if (array_length(controller.restrictedRooms) > 0)
		{
			if (!ArrayContainsValue(controller.restrictedRooms, room))
			{
				continue;
			}
		}
		
		if (!layer_exists(controller.layerName)) {
			var layerDepth = controllerLayers[? controller.layerName] ?? depth;
			layer_create(layerDepth, controller.layerName);
		}
		var controllerInstance = instance_create_layer(-1, -1, controller.layerName, controller.objectIndex);
		controller.SetInstance(controllerInstance);
	}
	
	// CONSOLE LOG
	if (instance_exists(controller.instance))
	{
		show_debug_message(string("->Instance loaded {0}", object_get_name(controller.objectIndex)));	
	}
}

// EXECUTE CUSTOM USER EVENT 0 OF CONTROLLERS ON ROOM START
// ORDERED BY CONTROLLER LIST
for (var i = 0; i < controllerCount; i++)
{
	var controller = controllers[@ i];
	if (instance_exists(controller.instance))
	{
		with (controller.instance)
		{
			event_perform(ev_other, ev_user0);
		}
	}
}

switch (room)
{
	case roomLaunch: {
		// GO TO MAIN MENU AFTER LAUNCH
		// ROOM CHANGE HANDLER YET LOADED
		room_goto(roomMainMenu);
	} break;
	case roomLoadResources: {
		// LOAD SAVE FILE
		if (global.GameSaveHandlerRef.ReadSaveFromFile())
		{
			// LOAD PLAYER DATA
			if (global.PlayerDataHandlerRef.LoadPlayerData(global.GameSaveHandlerRef.game_save_data))
			{
				if (!global.MultiplayerMode)
				{
					var fastTravelTargetRoom = ROOM_DEFAULT;
					// FETCH LAST KNOWN LOCATION FROM GAME SAVE
					if (!is_undefined(global.PlayerDataHandlerRef.last_known_location))
					{
						if (!is_undefined(global.PlayerDataHandlerRef.last_known_location.room_index))
						{
							fastTravelTargetRoom = global.PlayerDataHandlerRef.last_known_location.room_index;
						}
					}
				
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							sprFloppyDisk, "New game save started",
							string("Save: '{0}'", global.GameSaveHandlerRef.save_name),
							NOTIFICATION_TYPE.Popup
						)
					);
					// GO TO THE LAST KNOWN PLAYER LOCATION
					global.RoomChangeHandlerRef.RequestRoomChange(fastTravelTargetRoom);
				} else {
					// REQUEST JOIN GAME
					if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.CONNECTED_SAVE_SELECTED)
					{
						global.NetworkHandlerRef.RequestJoinGame();
					}
				}		
			} else {
				var consoleLog = string("Failed to load and parse player data from save file '{0}'", global.GameSaveHandlerRef.save_file_name);
				global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
			
				global.NotificationHandlerRef.AddNotification(
					new Notification(
						sprFloppyDiskBroken, "Failed to load game save",
						string("Save: '{0}'", global.GameSaveHandlerRef.save_name),
						NOTIFICATION_TYPE.Popup
					)
				);
				// RETURN TO MAIN MENU
				global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);
			}
		} else {
			var consoleLog = string("Failed to load and parse save file '{0}'", global.GameSaveHandlerRef.save_file_name);
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, consoleLog);
		
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					sprFloppyDiskBroken, "Failed to load game save",
					string("Save: '{0}'", global.GameSaveHandlerRef.save_name),
					NOTIFICATION_TYPE.Popup
				)
			);
			// RETURN TO MAIN MENU
			global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MAIN_MENU);	
		}
	} break;
	case roomMainMenu:
	{
		// RESET GAME SAVE DATA CACHE
		if (!is_undefined(global.GameSaveHandlerRef.game_save_data))
		{
			global.GameSaveHandlerRef.ResetGameSaveData();
		}
		
		// DISCONNECT FROM THE SERVER WHEN RETURNING TO MAINMENU
		if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.TIMED_OUT)
		{
			global.NetworkHandlerRef.network_status = NETWORK_STATUS.OFFLINE;
			if (global.NetworkHandlerRef.client_id != UNDEFINED_UUID)
			{
				global.NetworkHandlerRef.RequestDisconnectSocket();
			}
			// CONSOLE LOG
			global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.ERROR, "Connection timed out :(");
			// ADD POP-UP NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined, "Connection timed out :(",
					undefined, NOTIFICATION_TYPE.Log
				)
			);
		} else if (global.NetworkHandlerRef.network_status != NETWORK_STATUS.OFFLINE)
		{
			if (global.NetworkHandlerRef.client_id != UNDEFINED_UUID)
			{
				global.NetworkHandlerRef.RequestDisconnectSocket();
			}
		}
	} break;
	default:
	{
		if (IS_ROOM_IN_GAME_WORLD)
		{
			// START ROOM FADE-IN EFFECT
			roomFadeAlpha = roomFadeAlphaStart;
			
			if (!global.MultiplayerMode)
			{
				// TODO: Fix this code
				// READ ROOM SAVE DATA FROM FILE
				//global.GameSaveHandlerRef.ReadRoomDataFromFile();
			} else {
				// SYNC-INSTANCE CALL ON IN-GAME ROOM START
				global.NetworkHandlerRef.OnRoomStart();
			}
		
			// EXECUTE CUSTOM USER EVENT 0 OF OTHER OBJECTS ON ROOM START
			var objectParentsWithEvent = OBJECT_PARENTS_WITH_EVENT_0;
			var objectParentCount = array_length(objectParentsWithEvent);
			for (var i = 0; i < objectParentCount; i++)
			{
				var objectIndex = objectParentsWithEvent[@ i];
				var instanceCount = instance_number(objectIndex);
				for (var j = 0; j < instanceCount; j++)
				{
					var instance = instance_find(objectIndex, j);
					if (instance_exists(instance))
					{
						with (instance)
						{
							event_perform(ev_other, ev_user0);
						}
					}
				}
			}
		
			// RESET GAME SAVE IS LOADED FOR THE FIRST TIME FLAG
			global.GameSaveHandlerRef.is_save_loading_first_time = false;
		}
	}
}