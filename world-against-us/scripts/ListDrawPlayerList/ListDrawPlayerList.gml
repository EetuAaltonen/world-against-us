function ListDrawPlayerList(_position, _size, _playerListInfo)
{
	var outlineWidth = 2;
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X, _position.Y,
		_size.w, _size.h,
		0, c_white, 1
	);
	
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X + outlineWidth, _position.Y + outlineWidth,
		_size.w - (outlineWidth * 2), _size.h - (outlineWidth * 2),
		0, c_black, 1
	);

	draw_set_font(font_small);
	draw_set_color(c_white);
	draw_set_valign(fa_middle);
	draw_text(_position.X + 10, _position.Y + (_size.h * 0.5), string("{0}", _playerListInfo.player_name));
	draw_text(_position.X + (_size.w * 0.5), _position.Y + (_size.h * 0.5), string("Location: {0}", _playerListInfo.room_name));
	draw_set_halign(fa_right);
	draw_text(_position.X + _size.w - 10, _position.Y + (_size.h * 0.5), string("Region id: {0}", _playerListInfo.region_id));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}