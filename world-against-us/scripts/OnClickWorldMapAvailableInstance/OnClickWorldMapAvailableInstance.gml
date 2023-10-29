function OnClickWorldMapAvailableInstance()
{
	if (global.MultiplayerMode)
	{
		if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.WorldMapFastTravelQueue, [GAME_WINDOW.WorldMapFastTravelQueue]))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowWorldMapFastTravelQueue(GAME_WINDOW.WorldMapFastTravelQueue, parentWindow.zIndex - 1)
			]);
			
			// REQUEST FAST TRAVEL
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_FAST_TRAVEL, global.NetworkHandlerRef.client_id);
			var fastTravelInfo = new WorldMapFastTravelInfo(global.NetworkRegionHandlerRef.region_id, elementData.region_id, elementData.room_index);
			var networkPacket = new NetworkPacket(networkPacketHeader, fastTravelInfo);
			global.NetworkHandlerRef.AddPacketToQueue(networkPacket, true);
		}
	}
}