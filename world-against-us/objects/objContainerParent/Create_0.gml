// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Loot";
interactionFunction = function()
{
	if (!is_undefined(inventory))
	{
		if (!isContainerSearched)
		{
			var lootTable = global.LootTableData[? lootTableTag];
			var lootData = lootTable.RollLoot();
	
			var lootCount = array_length(lootData);
			for (var i = 0; i < lootCount; i++)
			{
				var lootEntry = lootData[@ i];
				var item = global.ItemDatabase.GetItemByName(lootEntry.name);
				item.is_known = false;
				repeat(lootEntry.count)
				{
					var lootItemGridIndex = inventory.AddItem(item, undefined, false, item.is_known);
					if (is_undefined(lootItemGridIndex)) break;
				}
			}
		
			isContainerSearched = true;
		}
	
		var guiState = new GUIState(
			GUI_STATE.LootContainer, undefined, undefined,
			[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.LootContainer], GUI_CHAIN_RULE.OverwriteAll
		);
		if (global.GUIStateHandlerRef.RequestGUIState(guiState))
		{
			global.GameWindowHandlerRef.OpenWindowGroup([
				CreateWindowPlayerBackpack(-1),
				CreateWindowLootContainer(-1, inventory)
			]);
		}
	}
	
	// TODO: Networking disabled for now
	/*if (!requestContent)
	{
		// NETWORKING CONTAINER REQUEST CONTENT
		var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_REQUEST_CONTENT);
			
		buffer_write(networkBuffer, buffer_text , containerId);
		global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
			
		requestContent = true;
	}*/
}

containerId = undefined;
lootTableTag = undefined;
inventory = undefined;

requestContent = false;
isContainerSearched = false;