interactionText = "Enter to Library";
interactionFunction = function()
{
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_LIBRARY
		);
	} else {
		global.FastTravelHandlerRef.RequestRoomChange(ROOM_INDEX_LIBRARY);
	}
}