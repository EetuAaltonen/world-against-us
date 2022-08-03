draw_self();

if (loot != noone)
{
	if (insideInteractionRange && !loot.showInventory)
	{
		draw_text_color(
			x, y - 100, "Loot",
			c_black, c_black, c_black, c_black, 1
		);	
	}
}
