function AnimationCurve(_curveIndex, _channelIndex, _duration) constructor
{
	curveIndex = _curveIndex;
	channelIndex = _channelIndex;
	duration = _duration;
	
	startPosition = 0;
	position = startPosition;
	stepPosition = undefined;
	endPosition = 1;
	
	animationCurve = undefined;
	curveChannel = undefined;
	
	onCreate = true;
	isPlaying = false;
	isReversed = false;
	
	Init();
	
	static Init = function()
	{
		animationCurve = animcurve_get(curveIndex);
		curveChannel = animcurve_get_channel(animationCurve, channelIndex);
		position = startPosition;
		stepPosition = ((1 / room_speed) / duration);
	}
	
	static Play = function()
	{
		isPlaying = true;
		isReversed = false;
		position = startPosition;
	}
	
	static PlayReversed = function()
	{
		isPlaying = true;
		isReversed = true;
		position = endPosition;
	}
	
	static Update = function()
	{
		if (onCreate)
		{
			onCreate = false;
			Init();
		}
		
		if (isPlaying)
		{
			if (!isReversed)
			{
				if (position >= endPosition)
				{
					isPlaying = false;
				} else {
					position = Approach(position, endPosition, stepPosition);
				}
			} else {
				if (position <= startPosition)
				{
					isPlaying = false;
				} else {
					position = Approach(position, startPosition, stepPosition);
				}
			}
		}
	}
	
	static GetValue = function()
	{
		return animcurve_channel_evaluate(curveChannel, position);
	}
	
	static IsEnded = function()
	{
		var isEnded = false;
		if (!isReversed)
		{
			isEnded = (!isPlaying && position >= endPosition);
		} else {
			isEnded = (!isPlaying && position <= startPosition);	
		}
		return isEnded;
	}
	
	static Reset = function()
	{
		isPlaying = false;
		isReversed = false;
	}
}