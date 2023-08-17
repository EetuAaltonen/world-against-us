// CHECK GUI STATE
if (!global.GUIStateHandlerRef.IsGUIStateClosed()) return;

if (instance_exists(global.InstancePlayer))
{
	insideInteractionRange = (point_distance(x, y, global.InstancePlayer.x, global.InstancePlayer.y) < interactionRange);
	
	if (insideInteractionRange && keyboard_check_released(ord("F")))
	{
		global.ObjTempInventory.inventory = stock;
		// TODO: Fix GUI state
		//RequestGUIState(GUI_STATE.Merchant);
	}
}
