function OnClickActionMenuDelete()
{
	// DELETE ITEM
	var item = parentElement.targetItem;
	var inventory = item.sourceInventory;
	inventory.RemoveItemByGridIndex(item.grid_index);
	
	// CLOSE ACTION MENU
	global.GUIStateHandler.CloseCurrentGUIState();
}