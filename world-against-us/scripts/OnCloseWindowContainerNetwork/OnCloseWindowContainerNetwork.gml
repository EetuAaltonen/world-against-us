function OnCloseWindowContainerNetwork(_containerId)
{
	// CONTAINER INVENTORY STREAM
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.START_CONTAINER_INVENTORY_STREAM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM);
	// TODO: Block window closing, to prevent container inventory action interrupts while exhanging network acknowledgments
	// How about on disconnect?
	// CONTAINER INVENTORY ACTIONS
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_DEPOSIT_ITEM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_STACK_ITEM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_IDENTIFY_ITEM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_WITHDRAW_ITEM);
	global.NetworkHandlerRef.CancelPacketsSendQueueAndTrackingByMessageType(MESSAGE_TYPE.CONTAINER_INVENTORY_DELETE_ITEM);
	
	// RESET ACTIVE INVENTORY STREAM
	global.NetworkRegionObjectHandlerRef.active_inventory_stream = undefined;
	
	// RELEASE CONTAINER CONTENT ACCESS
	if (global.NetworkRegionObjectHandlerRef.requested_container_access == _containerId)
	{
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.RELEASE_CONTAINER_CONTENT);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			{
				region_id: global.NetworkRegionHandlerRef.region_id,
				container_id: _containerId
			},
			PACKET_PRIORITY.DEFAULT,
			AckTimeoutFuncResend
		);
		if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
		{
			show_debug_message("Failed to request container content");
		}
	}
	global.NetworkRegionObjectHandlerRef.requested_container_access = undefined;
}