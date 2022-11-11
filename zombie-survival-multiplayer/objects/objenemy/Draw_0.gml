draw_self();

// DEBUG INFO
/*
draw_circle_color(x, y, aggroRadius, c_red, c_red, true);
draw_circle_color(x, y, stopRadius, c_green, c_green, true);
*/

if (!is_undefined(character))
{
	if (character.hp < character.maxHp)
	{
		var barScale = 100 * (character.hp / character.maxHp);
		draw_sprite_ext(sprHpBar, 0, x - (barScale * 0.5), y + 128, barScale, 1, 0, c_white, 1);
	}
}
