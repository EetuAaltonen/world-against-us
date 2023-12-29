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
			global.FastTravelHandlerRef.RequestFastTravel(fastTravelInfo);
		} else {
			global.FastTravelHandlerRef.RequestRoomChange(worldMapLocationData.room_index);
		}
	}
}