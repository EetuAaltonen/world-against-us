// INHERIT THE PARENT EVENT
event_inherited();

if (!is_undefined(character))
{
	if (character.behavior == CHARACTER_BEHAVIOR.REMOTE_PLAYER)
	{
		draw_set_font(font_tiny_bold);
		draw_set_halign(fa_center);
		draw_set_color(c_orange);
		draw_text(x, y - 80, character.name);
		
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}