interactionText = "Enter to Market";
interactionFunction = function()
{
	// TODO: Proper request room change logic
	if (global.MultiplayerMode)
	{
		InteractionFuncFastTravelSpotRequest(
			global.NetworkRegionHandlerRef.region_id,
			global.NetworkRegionHandlerRef.region_id,
			ROOM_INDEX_MARKET
		);
	} else {
		room_goto(roomMarket);
	}
}