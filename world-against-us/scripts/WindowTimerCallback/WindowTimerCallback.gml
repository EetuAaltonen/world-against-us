function WindowTimerCallback(_elementId, _relativePosition, _size, _backgroundColor, _callbackTime, _callbackFunction) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	// REMEMBER TO START TIMER ELSEWHERE
	timer = new Timer(_callbackTime);
	callback_function = _callbackFunction;
	
	static UpdateContent = function()
	{
		timer.Update();
		if (timer.IsTimerStopped())
		{
			timer.StopTimer();
			callback_function();
		}
	}
}