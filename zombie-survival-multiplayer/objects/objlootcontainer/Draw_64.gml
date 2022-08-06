if (loot != noone)
{
	if (loot.showInventory)
	{
		draw_set_alpha(0.8);
		draw_rectangle_color(
			global.GUIW * 0.6, 0,
			global.GUIW, global.GUIH,
			c_black, c_black, c_black, c_black, false
		);
		draw_set_alpha(1);
	
		loot.DrawGUI(global.GUIW * 0.6 + 10, 10);
	}
}
