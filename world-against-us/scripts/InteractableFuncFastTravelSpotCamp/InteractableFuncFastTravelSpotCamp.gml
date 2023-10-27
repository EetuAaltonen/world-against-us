function InteractableFuncFastTravelSpotCamp()
{
	if (global.MultiplayerMode)
	{
		// REQUEST INSTANCE LIST
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_INSTANCE_LIST, global.NetworkHandlerRef.client_id);
		var networkPacket = new NetworkPacket(networkPacketHeader, undefined);
			
		global.NetworkHandlerRef.AddPacketToQueue(networkPacket, true);
	}
	
	OpenWorldMap();
}