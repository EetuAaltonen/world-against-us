function GUIOnItemQuickTransfer(_inventory, _mouseHoverIndex)
{
	var itemGridIndex = _inventory.grid_data[_mouseHoverIndex.row][_mouseHoverIndex.col];
	if (!is_undefined(itemGridIndex))
	{
		var item = _inventory.GetItemByGridIndex(itemGridIndex).Clone();
		if (!is_undefined(item))
		{
			if (item.is_known)
			{
				if (_inventory.type == INVENTORY_TYPE.PlayerBackpack)
				{
					var targetInventory = global.ObjTempInventory.inventory;
					if (!is_undefined(targetInventory))
					{
						var transferItemGridIndex = targetInventory.AddItem(item, undefined, false, item.is_known);
						if (!is_undefined(transferItemGridIndex))
						{
							_inventory.RemoveItemByGridIndex(itemGridIndex);	
						}
					} else {
						if (item.category == "Magazine" || item.category == "Bullet" ||
							item.category == "Fuel Ammo")
						{
							if (!is_undefined(global.PlayerMagazinePockets))
							{
								var transferItemGridIndex = global.PlayerMagazinePockets.AddItem(item, undefined, false, item.is_known);
								if (!is_undefined(transferItemGridIndex))
								{
									_inventory.RemoveItemByGridIndex(itemGridIndex);
								}
							}
						} else if (item.category == "Medicine")
						{
							if (!is_undefined(global.PlayerMedicinePockets))
							{
								var transferItemGridIndex = global.PlayerMedicinePockets.AddItem(item, undefined, false, item.is_known);
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
						var transferItemGridIndex = global.PlayerBackpack.AddItem(item, undefined, false, item.is_known);
						if (!is_undefined(transferItemGridIndex))
						{
							if (_inventory.RemoveItemByGridIndex(itemGridIndex))
							{
								// NETWORKING REMOVE QUICK TRANSFER ITEM
								if (global.MultiplayerMode)
								{
									if (IsInventoryContainer(_inventory.type))
									{
										var containerInventoryActionInfo = new ContainerInventoryActionInfo(_inventory.inventory_id, itemGridIndex, undefined, undefined, undefined, undefined);
										var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_WITHDRAW_ITEM);
										var networkPacket = new NetworkPacket(
											networkPacketHeader,
											containerInventoryActionInfo,
											PACKET_PRIORITY.DEFAULT,
											AckTimeoutFuncResend
										);
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