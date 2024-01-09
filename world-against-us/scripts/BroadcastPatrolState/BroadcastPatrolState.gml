function BroadcastPatrolState(_patrolId, _aiState)
{
	if (global.MultiplayerMode)
	{
		if (global.NetworkHandlerRef.client_id == global.NetworkRegionHandlerRef.owner_client)
		{
			if (!is_undefined(_patrolId))
			{
				// UPDATE PATROL STATE
				var regionId = global.NetworkRegionHandlerRef.region_id;
				var patrolState = new PatrolState(regionId, _patrolId, _aiState);
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.PATROL_STATE);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					patrolState,
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to queue patrol state update");
				}
			}
		}
	}
}