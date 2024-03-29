function InteractionFuncLootContainer()
{
	if (!is_undefined(inventory))
	{
		if (global.MultiplayerMode)
		{
			if (is_undefined(global.NetworkRegionObjectHandlerRef.active_inventory_stream))
			{
				// REQUEST CONTAINER CONTENT
				var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.REQUEST_CONTAINER_CONTENT);
				var networkPacket = new NetworkPacket(
					networkPacketHeader,
					{
						// TODO: Use struct instead
						region_id: global.NetworkRegionHandlerRef.region_id,
						container_id: containerId
					},
					PACKET_PRIORITY.DEFAULT,
					AckTimeoutFuncResend
				);
				if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
				{
					show_debug_message("Failed to request container content");
				}
			}
		} else {
			if (!isContainerSearched)
			{
				RollContainerLoot(lootTableTag, inventory);
				isContainerSearched = true;
			}
		}
	
		var guiState = new GUIState(
			GUI_STATE.LootContainer, undefined, undefined,
			[
				CreateWindowPlayerBackpack(GAME_WINDOW.PlayerBackpack, -1),
				CreateWindowLootContainer(GAME_WINDOW.LootContainer, -1, inventory)
			],
			GUI_CHAIN_RULE.OverwriteAll
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
		{
			if (global.MultiplayerMode)
			{
				// SHOW CONTAINER INVENTORY LOADING ICON
				var worldMapWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.LootContainer);
				if (!is_undefined(worldMapWindow))
				{
					var containerInventoryLoadingElement = worldMapWindow.GetChildElementById("ContainerInventoryLoading");
					if (!is_undefined(containerInventoryLoadingElement))
					{
						containerInventoryLoadingElement.isVisible = true;
					}
				}
			}
		}
	}
}