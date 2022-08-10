if (!IsGUIStateClosed())
{
	// DRAW INVENTORY
	if (global.GUIState == GUI_STATE.PlayerBackpack ||
		global.GUIState == GUI_STATE.LootContainer ||
		global.GUIState == GUI_STATE.Merchant)
	{
		if (global.PlayerBackpack != noone)
		{
			draw_set_alpha(0.8);
			GUIDrawBox(0, 0, global.GUIW * 0.4, global.GUIH, c_black);
			draw_set_alpha(1);
	
			global.PlayerBackpack.DrawGUI(10, 10);
		}
	}
	
	// DRAW TEMP INVENTORY
	if (global.GUIState == GUI_STATE.LootContainer ||
		global.GUIState == GUI_STATE.Merchant)
	{
		if (global.ObjTempInventory != noone)
		{
			draw_set_alpha(0.8);
			draw_rectangle_color(
				global.GUIW * 0.6, 0,
				global.GUIW, global.GUIH,
				c_black, c_black, c_black, c_black, false
			);
			draw_set_alpha(1);
	
			global.ObjTempInventory.inventory.DrawGUI(global.GUIW * 0.6 + 10, 10);
		}
	}
}
