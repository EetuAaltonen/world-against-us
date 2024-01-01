function OnClickWorldMapFastTravel()
{
	var worldMapLocationData = metadata;
	if (!is_undefined(worldMapLocationData))
	{
		var fastTravelInfo = new WorldMapFastTravelInfo(
			undefined, undefined,
			worldMapLocationData.room_index
		);
		if (global.MultiplayerMode)
		{
			// FETCH SOURCE AND DESTINATION REGION IDS
			fastTravelInfo.source_region_id = global.NetworkRegionHandlerRef.region_id;
			fastTravelInfo.destination_region_id = global.NetworkRegionHandlerRef.region_id;
		}
		global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
	}
}