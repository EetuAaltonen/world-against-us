function TimerRatePerSecond(_rate)
{
	return (game_get_speed(gamespeed_fps) / (_rate));
}

function TimerRatePerMinute(_rate)
{
	return (game_get_speed(gamespeed_fps) / (_rate / 60));
}

function TimerFromSeconds(_seconds)
{
	return game_get_speed(gamespeed_fps) * _seconds;
}
function TimerFromMilliseconds(_milliseconds)
{
	return TimerFromSeconds(_milliseconds * 0.001);
}