function ListDrawConsoleLog(_position, _size, _consoleLog, _elementStyle)
{
	draw_set_font(_elementStyle.text_font);
	var textColor = global.ConsoleHandlerRef.GetConsoleTextColor(_consoleLog.console_log_type);
	draw_text_color(
		_position.X + 10, _position.Y + (_size.h * 0.5),
		_consoleLog.console_log_message,
		textColor, textColor, textColor, textColor, 1
	);
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}