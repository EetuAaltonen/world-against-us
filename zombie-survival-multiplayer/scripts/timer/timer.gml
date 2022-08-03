function TimerRatePerMinute(_rate, _cycleDelay = 0)
{
	return ((1 * room_speed) / (_rate / 60)) - _cycleDelay;
}