interactionText = "Exit the Library";
interactionFunction = function()
{
	var fastTravelInfo = new WorldMapFastTravelInfo(undefined, undefined, ROOM_INDEX_TOWN);
	if (global.MultiplayerMode)
	{
		fastTravelInfo.source_region_id = global.NetworkRegionHandlerRef.region_id;
		fastTravelInfo.destination_region_id = global.NetworkRegionHandlerRef.prev_region_id;
	}
	global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
}