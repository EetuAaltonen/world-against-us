function OnClickWorldMapAvailableInstance()
{
	if (global.MultiplayerMode)
	{
		var fastTravelInfo = new WorldMapFastTravelInfo(
			global.NetworkRegionHandlerRef.region_id,
			elementData.region_id,
			elementData.room_index
		);
		global.FastTravelHandlerRef.RequestFastTravel(fastTravelInfo);
	}
}