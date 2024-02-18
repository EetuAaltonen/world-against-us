function NetworkInventoryDepositItem(_inventory, _depositGridIndex)
{
	if (global.MultiplayerMode)
	{
		if (IsInventoryContainer(_inventory.type))
		{
			var depositedItem = _inventory.GetItemByGridIndex(_depositGridIndex);
			if (!is_undefined(depositedItem))
			{
				var containerInventoryActionInfo = new ContainerInventoryActionInfo(_inventory.inventory_id, undefined, undefined, undefined, undefined, depositedItem);
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_DEPOSIT_ITEM);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					containerInventoryActionInfo.ToJSONStruct(),
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to add item to container inventory");
				}
			}
		}
	}
}