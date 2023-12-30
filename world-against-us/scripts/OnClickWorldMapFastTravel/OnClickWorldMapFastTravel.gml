function OnClickWorldMapFastTravel()
{
	var worldMapLocationData = metadata;
	if (!is_undefined(worldMapLocationData))
	{
		if (global.MultiplayerMode)
		{
			var fastTravelInfo = new WorldMapFastTravelInfo(
				global.NetworkRegionHandlerRef.region_id,
				global.NetworkRegionHandlerRef.region_id,
				worldMapLocationData.room_index
			);
			global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
		} else {
			global.RoomChangeHandlerRef.RequestRoomChange(worldMapLocationData.room_index);
		}
	}
}