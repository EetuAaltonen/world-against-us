function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (!is_undefined(itemGridIndex))
	{
		var sourceItem = _inventory.GetItemByGridIndex(itemGridIndex).Clone();
		if (!is_undefined(sourceItem))
		{
			if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
			{
				var targetInventory = global.ObjTempInventory.inventory;
				if (!is_undefined(targetInventory))
				{
					var transferItemGridIndex = targetInventory.AddItem(sourceItem, undefined, false, sourceItem.is_known);
					if (!is_undefined(transferItemGridIndex))
					{
						_inventory.RemoveItemByGridIndex(itemGridIndex);	
					}
				} else {
					if (sourceItem.category == "Magazine" || sourceItem.category == "Bullet" ||
						sourceItem.category == "Fuel Ammo")
					{
						if (!is_undefined(global.PlayerMagazinePockets))
						{
							var transferItemGridIndex = global.PlayerMagazinePockets.AddItem(sourceItem, undefined, false, sourceItem.is_known);
							if (!is_undefined(transferItemGridIndex))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					} else if (sourceItem.category == "Medicine")
					{
						if (!is_undefined(global.PlayerMedicinePockets))
						{
							var transferItemGridIndex = global.PlayerMedicinePockets.AddItem(sourceItem, undefined, false, sourceItem.is_known);
							if (!is_undefined(transferItemGridIndex))
							{
								_inventory.RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}
				}
			} else {
				if (!is_undefined(global.PlayerBackpack))
				{
					var transferItemGridIndex = global.PlayerBackpack.AddItem(sourceItem, undefined, false, sourceItem.is_known);
					if (!is_undefined(transferItemGridIndex))
					{
						if (_inventory.RemoveItemByGridIndex(itemGridIndex))
						{
							// NETWORKING REMOVE QUICK TRANSFER ITEM
							if (global.MultiplayerMode)
							{
								if (_inventory.type == INVENTORY_TYPE.LootContainer)
								{
									var containerInventoryActionInfo = new ContainerInventoryActionInfo(_inventory.inventory_id, itemGridIndex, undefined, undefined, undefined, undefined);
									var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_REMOVE_ITEM, global.NetworkHandlerRef.client_id);
									var networkPacket = new NetworkPacket(networkPacketHeader, containerInventoryActionInfo);
									if (global.NetworkPacketTrackerRef.SetNetworkPacketAcknowledgment(networkPacket))
									{
										if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
										{
											show_debug_message("Failed to remove item from container inventory");
										}
									}
								}
							}
						}
					}
				}
			}	
		}
	}
}