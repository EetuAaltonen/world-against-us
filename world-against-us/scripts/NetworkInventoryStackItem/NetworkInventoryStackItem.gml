function NetworkInventoryStackItem(_inventory, _sourceQuantity, _sourceItem, _targetItem)
{
	if (global.MultiplayerMode)
	{
		if (IsInventoryContainer(_inventory.type))
		{
			// TODO: Simplify combine logic
			var stackedSourceItem = _sourceItem.Clone();
			// PATCH GRID INDEX
			stackedSourceItem.grid_index = _targetItem.grid_index.Clone();
			// PATCH STACK OPERATION QUANTITY
			stackedSourceItem.quantity = _sourceQuantity - _sourceItem.quantity;
			var containerInventoryActionInfo = new ContainerInventoryActionInfo(_inventory.inventory_id, undefined, undefined, undefined, undefined, stackedSourceItem);
			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STACK_ITEM);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				containerInventoryActionInfo.ToJSONStruct(),
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
			{
				show_debug_message("Failed to stack item to container inventory");
			}
			// DELETE TEMP STACKED SOURCE ITEM
			stackedSourceItem.OnDestroy();
			stackedSourceItem = undefined;
		}
	}
}