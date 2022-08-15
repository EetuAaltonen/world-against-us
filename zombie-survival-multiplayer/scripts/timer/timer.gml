function TimerRatePerSecond(_rate)
{
	return (room_speed / (_rate));
}

function TimerRatePerMinute(_rate)
{
	return (room_speed / (_rate / 60));
}

function TimerFromSeconds(_seconds)
{
	return room_speed * _seconds;
}
function TimerFromMilliseconds(_milliseconds)
{
	return TimerFromSeconds(_milliseconds * 0.001);
}