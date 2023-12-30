interactionText = "Fast travel to Camp";
interactionFunction = function()
{
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_CAMP
		);
	} else {
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_CAMP);
	}
}