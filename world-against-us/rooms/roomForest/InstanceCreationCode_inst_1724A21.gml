interactionText = "Fast travel to Camp";
interactionFunction = function()
{
	var fastTravelInfo = new WorldMapFastTravelInfo(undefined, undefined, ROOM_INDEX_CAMP);
	if (global.MultiplayerMode)
	{
		fastTravelInfo.source_region_id = global.NetworkRegionHandlerRef.region_id;
		fastTravelInfo.destination_region_id = global.NetworkRegionHandlerRef.region_id;
	}
	global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
}