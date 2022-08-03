if (inventory != noone)
{
	if (inventory.showInventory)
	{
		draw_set_alpha(0.8);
		draw_rectangle_color(
			0, 0,
			global.ViewW * 0.4, global.ViewH,
			c_black, c_black, c_black, c_black, false
		);
		draw_set_alpha(1);
	
		inventory.DrawGUI(100, 100);
	}
}
