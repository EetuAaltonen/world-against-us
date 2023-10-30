function OnClickWorldMapFastTravel()
{
	// TODO: Fetch destination room from global world data location map by room index
	if (global.MultiplayerMode)
	{
		if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.WorldMapFastTravelQueue, [GAME_WINDOW.WorldMapFastTravelQueue]))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowWorldMapFastTravelQueue(GAME_WINDOW.WorldMapFastTravelQueue, parentWindow.zIndex - 1)
			]);
			
			// REQUEST FAST TRAVEL
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_FAST_TRAVEL, global.NetworkHandlerRef.client_id);
			var fastTravelInfo = new WorldMapFastTravelInfo(global.NetworkRegionHandlerRef.region_id, global.NetworkRegionHandlerRef.region_id, metadata.room_index);
			var networkPacket = new NetworkPacket(networkPacketHeader, fastTravelInfo);
			if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
			{
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to request fast travel");
				}
			}
		}
	} else {
		room_goto(metadata.destination_room);
	}
}