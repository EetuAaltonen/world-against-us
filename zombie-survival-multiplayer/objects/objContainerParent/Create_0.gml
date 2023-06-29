// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Loot";
interactionFunction = function()
{
	if (is_undefined(inventory))
	{
		var lootTable = global.LootTableData[? lootTableTag];
		var lootData = lootTable.RollLoot();
	
		inventory = new Inventory(containerId, INVENTORY_TYPE.LootContainer);
	
		var lootCount = array_length(lootData);
		for (var i = 0; i < lootCount; i++)
		{
			var lootEntry = lootData[@ i];
			// TODO: Stack or separate items by count and stackable values
			var item = global.ItemData[? lootEntry.name];
			if (item.max_stack <= 1)
			{
				for (var j = 0; j < lootEntry.count; j++)
				{
					inventory.AddItem(item.Clone(), item.grid_index, false, true);
				}
			} else {
				inventory.AddItem(item.Clone(lootEntry.count), item.grid_index, false, true);
			}
		}
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

inventory = undefined;
requestContent = false;