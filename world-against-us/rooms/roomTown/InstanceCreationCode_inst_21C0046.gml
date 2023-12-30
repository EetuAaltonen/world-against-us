interactionText = "Enter to Office";
interactionFunction = function()
{
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_OFFICE
		);
	} else {
		global.RoomChangeHandlerRef.RequestRoomChange(ROOM_INDEX_OFFICE);
	}
}