function DebugMonitorSample(_timeStamp, _value) constructor
{
	time_stamp = _timeStamp;
	value = _value;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
		return;
	}
}