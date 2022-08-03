if (loot != noone)
{
	if (loot.showInventory)
	{
		draw_set_alpha(0.8);
		draw_rectangle_color(
			global.ViewW * 0.60, 0,
			global.ViewW, global.ViewH,
			c_black, c_black, c_black, c_black, false
		);
		draw_set_alpha(1);
	
		loot.DrawGUI(global.ViewW * 0.60 + 100, 100);
	}
}
