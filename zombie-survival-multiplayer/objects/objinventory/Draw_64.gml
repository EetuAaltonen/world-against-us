if (inventory != noone)
{
	if (inventory.showInventory)
	{
		draw_set_alpha(0.8);
		GUIDrawBox(0, 0, global.GUIW * 0.4, global.GUIH, c_black);
		draw_set_alpha(1);
	
		inventory.DrawGUI(10, 10);
	}
}
