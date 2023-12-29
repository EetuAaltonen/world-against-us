interactionText = "Exit the Library";
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
		global.FastTravelHandlerRef.RequestRoomChange(ROOM_INDEX_TOWN);
	}
}