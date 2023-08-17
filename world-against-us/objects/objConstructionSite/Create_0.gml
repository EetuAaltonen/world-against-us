// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Build";
interactionFunction = function()
{
	var guiState = new GUIState(
		GUI_STATE.ConstructionSite, undefined, undefined,
		[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.ConstructionSite], GUI_CHAIN_RULE.OverwriteAll
	);
	if (global.GUIStateHandlerRef.RequestGUIState(guiState))
	{
		global.GameWindowHandlerRef.OpenWindowGroup([
			CreateWindowPlayerBackpack(-1),
			CreateWindowConstructionSite(-1, materialSlotInventories, self)
		]);
	}
}

materialSlotInventories = [];
var materialSlotCount = 3;
for (var i = 0; i < materialSlotCount; i++)
{
	var materialSlotInventory = new Inventory(string("MaterialSlot{0}", i), INVENTORY_TYPE.ConstructionSite, { columns: 4, rows: 4 }, ["Material"]);
	array_push(materialSlotInventories, materialSlotInventory);
}