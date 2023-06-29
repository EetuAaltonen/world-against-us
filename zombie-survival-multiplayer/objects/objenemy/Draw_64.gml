if (!is_undefined(character))
{
	if (character.total_hp_percent < 100)
	{
		var barGUIPosition = PositionToGUI(new Vector2(x, y));
		var barScale = character.total_hp_percent;
		draw_sprite_ext(
			sprHpBar, 0,
			barGUIPosition.X - (barScale * 0.5),
			barGUIPosition.Y + 128, barScale,
			1, 0, c_white, 1
		);
	}
}
