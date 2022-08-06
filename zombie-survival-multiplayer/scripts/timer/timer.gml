function TimerRatePerMinute(_rate)
{
	return ((1 * room_speed) / (_rate / 60));
}

function TimerFromSeconds(_seconds)
{
	return room_speed * _seconds;
}