function SkeletalSpriteAnimationEventData(_objectEventType, _eventName, _eventFunc) constructor
{
	object_event_type = _objectEventType;
	event_name = _eventName;
	event_frames = [-1];
	event_function = _eventFunc;
	is_initialized = false;
	
	static Initialize = function(_instanceRef, _animationName)
	{
		if (!is_initialized)
		{
			with (_instanceRef)
			{
				other.event_frames = skeleton_animation_get_event_frames(_animationName, other.event_name);
				FormatArrayElements(other.event_frames, function(_elem) {
					return floor(_elem);
				});
			}
		}
		is_initialized = true;
	}
}