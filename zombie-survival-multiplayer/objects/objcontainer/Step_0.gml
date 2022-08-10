// CHECK GUI STATE
if (!IsGUIStateClosed()) return;

if (global.ObjPlayer != noone)
{
	insideInteractionRange = (point_distance(x, y, global.ObjPlayer.x, global.ObjPlayer.y) < interactionRange);
	
	if (insideInteractionRange && keyboard_check_released(ord("F")))
	{
		global.ObjTempInventory.inventory = inventory;
		RequestGUIState(GUI_STATE.LootContainer);
	}
}
