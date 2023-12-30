interactionText = "Exit the Market";
interactionFunction = function()
{
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.prev_region_id,
			ROOM_INDEX_TOWN
		);
	} else {
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_TOWN);
	}
}