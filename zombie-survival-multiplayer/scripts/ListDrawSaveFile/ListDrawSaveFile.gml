function ListDrawSaveFile(_position, _size, _fileName)
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
	
	draw_set_valign(fa_middle);
	var parsedSaveName = string_replace(_fileName, SAVE_FILE_SUFFIX_PLAYER_DATA, "");
	draw_text(_position.X + 10, _position.Y + (_size.h * 0.5), string("{0}", parsedSaveName));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}