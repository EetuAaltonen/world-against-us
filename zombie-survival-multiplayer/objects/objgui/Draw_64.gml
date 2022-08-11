if (!IsGUIStateClosed())
{
	// DRAW INVENTORY
	if (global.GUIState == GUI_STATE.PlayerBackpack ||
		global.GUIState == GUI_STATE.LootContainer ||
		global.GUIState == GUI_STATE.Merchant)
	{
		if (global.PlayerBackpack != noone)
		{
			draw_sprite_ext(sprGUIBg, 0, 0, 0, global.GUIW * 0.4, global.GUIH, 0, c_white, 0.8);
			global.PlayerBackpack.DrawGUI(10, 10);
		}
	}
	
	// DRAW TEMP INVENTORY
	if (global.GUIState == GUI_STATE.LootContainer ||
		global.GUIState == GUI_STATE.Merchant)
	{
		if (global.ObjTempInventory != noone)
		{
			draw_sprite_ext(sprGUIBg, 0, global.GUIW * 0.6, 0, global.GUIW * 0.4, global.GUIH, 0, c_white, 0.8);	
			global.ObjTempInventory.inventory.DrawGUI(global.GUIW * 0.6 + 10, 10);
		}
	}
}
