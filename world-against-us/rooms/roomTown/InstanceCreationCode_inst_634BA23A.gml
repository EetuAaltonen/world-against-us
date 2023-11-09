interactionText = "Fast travel to Camp";
interactionFunction = function()
{
	// TODO: Proper request room change logic
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.prev_region_id,
			ROOM_INDEX_CAMP
		);
	} else {
		room_goto(roomCamp);
	}
}