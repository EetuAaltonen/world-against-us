interactionText = "Exit the Office";
interactionFunction = function()
{
	// OpenWorldMap();
	// TODO: Proper request room change logic
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.prev_region_id,
			ROOM_INDEX_TOWN
		);
	} else {
		room_goto(roomTown);
	}
}