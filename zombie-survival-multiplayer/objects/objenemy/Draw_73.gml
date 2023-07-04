if (!is_undefined(character))
{
	if (character.total_hp_percent < 100)
	{
		var barScale = ceil(character.total_hp_percent * 0.5);
		draw_sprite_ext(
			sprHpBar, 0,
			x - (barScale * 0.5), y + (sprite_height * 0.5) + 10,
			barScale, 1, 0, c_white, 1
		);
	}
}
