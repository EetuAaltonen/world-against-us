if (async_load[? "size"] > 0)
{
	var networkBuffer = async_load[? "buffer"];
	var packetHeader = PacketDecodeHeader(networkBuffer);
	
	if (!is_undefined(packetHeader.clientId))
	{
		if (!is_undefined(containerId))
		{
			switch (packetHeader.messageType)
			{
				case MESSAGE_TYPE.CONTAINER_REQUEST_CONTENT:
				{
					var container_id = buffer_read(networkBuffer, buffer_string);
					if (container_id == containerId)
					{
						var item_string = buffer_read(networkBuffer, buffer_string);
						var itemsStruct = json_parse(item_string);
						var itemCount = array_length(itemsStruct);
						
						inventory = new Inventory(containerId, INVENTORY_TYPE.LootContainer);
						for (var i = 0; i < itemCount; i++)
						{
							var itemStruct = itemsStruct[i];
							// SET KNOWN TO FALSE AND IGNORE NETWORK
							var item = JSONStructToItem(itemStruct);
							inventory.AddItem(item, item.grid_index, item.known, true);
						}
					
						global.ObjTempInventory.inventory = inventory;
						RequestGUIState(GUI_STATE.LootContainer);
				
						requestContent = false;
					}
				} break;
			}
		}
	}
}
