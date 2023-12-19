function ListDrawAvailableScoutInstance(_position, _size, _availableInstance)
{
	var outlineWidth = 2;
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X, _position.Y,
		_size.w, _size.h,
		0, c_black, 1
	);
	
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X + outlineWidth, _position.Y + outlineWidth,
		_size.w - (outlineWidth * 2), _size.h - (outlineWidth * 2),
		0, c_ltgray, 1
	);

	draw_set_font(font_small);
	draw_set_valign(fa_middle);
	draw_text(_position.X + 10, _position.Y + (_size.h * 0.5), string("{0}", _availableInstance.region_id));
	draw_text(_position.X + 40, _position.Y + (_size.h * 0.5), string("{0}", _availableInstance.room_index));
	draw_set_halign(fa_right);
	draw_text(_position.X + _size.w - 10, _position.Y + (_size.h * 0.5), string("{0} patrols | {1} players", _availableInstance.patrol_count, _availableInstance.player_count));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}