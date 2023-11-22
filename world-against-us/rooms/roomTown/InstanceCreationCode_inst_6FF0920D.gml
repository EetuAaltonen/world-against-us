interactionText = "Enter to Library";
interactionFunction = function()
{
	// TODO: Proper request room change logic
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_LIBRARY
		);
	} else {
		room_goto(roomLibrary);
	}
}