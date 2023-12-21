function NetworkInventoryStream(_inventory_id, _target_inventory, _stream_item_limit, _is_stream_sending, _stream_end_index) constructor
{
	inventory_id = _inventory_id;
	target_inventory = _target_inventory;
	
	stream_item_limit = _stream_item_limit;
	is_stream_sending = _is_stream_sending;
	
	stream_start_index = 0;
	stream_current_index = stream_start_index;
	stream_end_index = _stream_end_index;
	
	static SendNextInventoryStreamItems = function()
	{
		var isItemsSent = false;
		var items = FetchNextInventoryStreamItems();
		var itemCount = ds_list_size(items);
		if (itemCount > 0)
		{
			var regionId = global.NetworkRegionHandlerRef.region_id;
			var networkInventoryStreamItems = new NetworkInventoryStreamItems(regionId, inventory_id, items);

			var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
			var networkPacket = new NetworkPacket(
				networkPacketHeader,
				networkInventoryStreamItems.ToJSONStruct(),
				PACKET_PRIORITY.DEFAULT,
				AckTimeoutFuncResend
			);
			isItemsSent = global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
		} else {
			isItemsSent = SendEndInventoryStream();
		}
		return isItemsSent;
	}
	
	static RequestNextInventoryStreamItems = function()
	{
		var regionId = global.NetworkRegionHandlerRef.region_id;
		var networkInventoryStreamItems = new NetworkInventoryStreamItems(regionId, inventory_id, []);
		
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_STREAM);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			networkInventoryStreamItems,
			PACKET_PRIORITY.DEFAULT,
			AckTimeoutFuncResend
		);
		return global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
	}
	
	static SendEndInventoryStream = function()
	{
		EndInventoryStream();
		
		var regionId = global.NetworkRegionHandlerRef.region_id;
		var networkInventoryStreamItems = new NetworkInventoryStreamItems(regionId, inventory_id, []);
		
		var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.END_CONTAINER_INVENTORY_STREAM);
		var networkPacket = new NetworkPacket(
			networkPacketHeader,
			networkInventoryStreamItems,
			PACKET_PRIORITY.DEFAULT,
			AckTimeoutFuncResend
		);
		return global.NetworkHandlerRef.AddPacketToQueue(networkPacket);
	}
	
	static EndInventoryStream = function()
	{
		// HIDE CONTAINER INVENTORY LOADING ICON
		switch(target_inventory.type)
		{
			case INVENTORY_TYPE.LootContainer:
			{
				var lootContainerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.LootContainer);
				if (!is_undefined(lootContainerWindow))
				{
					var containerInventoryLoadingElement = lootContainerWindow.GetChildElementById("ContainerInventoryLoading");
					if (!is_undefined(containerInventoryLoadingElement))
					{
						containerInventoryLoadingElement.isVisible = false;
					}
				}
			} break;
			case INVENTORY_TYPE.StorageContainer:
			{
				var lootContainerWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.StorageContainer);
				if (!is_undefined(lootContainerWindow))
				{
					var containerInventoryLoadingElement = lootContainerWindow.GetChildElementById("ContainerInventoryLoading");
					if (!is_undefined(containerInventoryLoadingElement))
					{
						containerInventoryLoadingElement.isVisible = false;
					}
				}
			} break;
		}
		global.NetworkRegionObjectHandlerRef.active_inventory_stream = undefined;
	}
	
	static FetchNextInventoryStreamItems = function()
	{
		var items = ds_list_create();
		if (!is_undefined(target_inventory))
		{
			var lastItemIndex = stream_current_index + stream_item_limit;
			items = target_inventory.GetItemsByIndexRange(stream_current_index, lastItemIndex);
			stream_current_index += ds_list_size(items);
		}
		return items;
	}
}