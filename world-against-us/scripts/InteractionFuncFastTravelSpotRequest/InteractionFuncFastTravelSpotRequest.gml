function InteractionFuncFastTravelSpotRequest(_sourceRegionId, _destionationRegionId, _roomIndex)
{
	if (global.MultiplayerMode)
	{
		var fastTravelInfo = new WorldMapFastTravelInfo(_sourceRegionId, _destionationRegionId, _roomIndex);
		global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
	}
}