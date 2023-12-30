interactionText = "Enter to Market";
interactionFunction = function()
{
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_MARKET
		);
	} else {
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_MARKET);
	}
}