function NetworkPacketDeliveryPolicyHandler() constructor
{
	delivery_policies = ds_map_create();
	InitDeliveryPolicies();
	
	static InitDeliveryPolicies = function()
	{
		// CLEAR PREVIOUS VALUES
		ClearDSMapAndDeleteValues(delivery_policies);
		
		ds_map_add(delivery_policies, MESSAGE_TYPE.ACKNOWLEDGMENT, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.PING, new NetworkPacketDeliveryPolicy(true, false, false, false, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.DISCONNECT_FROM_HOST, new NetworkPacketDeliveryPolicy(false, false, false, false, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.INVALID_REQUEST, new NetworkPacketDeliveryPolicy(false, false, false, false, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.SERVER_ERROR, new NetworkPacketDeliveryPolicy(false, false, false, false, false));
		
		ds_map_add(delivery_policies, MESSAGE_TYPE.PLAYER_DATA_POSITION, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.PLAYER_DATA_MOVEMENT_INPUT, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.REMOTE_DATA_POSITION, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.REMOTE_DATA_MOVEMENT_INPUT, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		
		ds_map_add(delivery_policies, MESSAGE_TYPE.PATROLS_SNAPSHOT_DATA, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		
		ds_map_add(delivery_policies, MESSAGE_TYPE.OPERATIONS_SCOUT_STREAM, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		ds_map_add(delivery_policies, MESSAGE_TYPE.SCOUTING_DRONE_DATA_POSITION, new NetworkPacketDeliveryPolicy(false, true, true, true, false));
		
		// DEFAULT
		ds_map_add(
			delivery_policies, MESSAGE_TYPE.ENUM_LENGTH,
			new NetworkPacketDeliveryPolicy()
		);
	}
}