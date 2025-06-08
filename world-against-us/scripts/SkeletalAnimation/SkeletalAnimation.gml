function SkeletalAnimation(_instanceRef, _animEvents) constructor
{
	instance_ref = _instanceRef;
	// STOP DEFAULT SPRITE ANIMATION
	instance_ref.image_speed = 0;
	animation_skin = new SkeletalAnimationSkin(instance_ref);
	animation_events = _animEvents;
	
	animation_names = ds_list_create();
	GetAnimationNames(animation_names);
	active_animation_name = GetActiveAnimationName();
	current_frame = 0;
	frame_count = 0;
	
	animation_skeleton = new SkeletalAnimationSkeleton(instance_ref);
	InitAnimationEvents();
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(animation_names, ds_type_list);
		animation_names = undefined;
	}
	
	static Update = function()
	{
		current_frame = GetActiveAnimationFrame();
		CheckActiveAnimationEventFrames(ev_step);
	}
	
	static InitAnimationEvents = function()
	{
		var animationCount = ds_list_size(animation_names);
		for (var i = 0; i < animationCount; i++)
		{
			var animationName = animation_names[| i];
			if (!is_undefined(animationName))
			{
				var animationEvents = animation_events[? animationName];
				if (is_array(animationEvents))
				{
					var eventCount = array_length(animationEvents);
					for (var j = 0; j < eventCount; j++)
					{
						var animationEvent = animationEvents[@ j];
						if (animationEvent != undefined)
						{
							with (instance_ref)
							{
								animationEvent.event_frames = skeleton_animation_get_event_frames(
									animationName, animationEvent.event_name
								);
								FormatArrayElements(animationEvent.event_frames, function(_elem) {
									return floor(_elem);
								});
							}
						}
					}
				}
			}
		}
	}
	
	static SetAnimation = function(_animationName, _animationSpeed, _isLooping)
	{
		if (AnimationExists(_animationName))
		{
			with (instance_ref)
			{
				skeleton_animation_set(_animationName, _isLooping);
				image_speed = _animationSpeed;
			}
			active_animation_name = _animationName;
			frame_count = GetActiveAnimationFrameCount();
		}
	}
	
	static CheckActiveAnimationEventFrames = function(_eventType)
	{
		var activeAnimationEvents = animation_events[? active_animation_name];
		if (is_array(activeAnimationEvents))
		{
			var eventCount = array_length(activeAnimationEvents);
			for (var i = 0; i < eventCount; i++)
			{
				var animationEvent = activeAnimationEvents[@ i];
				if (animationEvent != undefined)
				{
					if (animationEvent.object_event_type == _eventType)
					{
						if (array_contains(animationEvent.event_frames, current_frame))
						{
							animationEvent.event_function(instance_ref);
						}
					}
				}
			}
		}
	}
	
	static GetAnimationNames = function(_listRef)
	{
		with (instance_ref)
		{
			skeleton_animation_list(sprite_index, _listRef);
		}
	}
	
	static AnimationExists = function(_animationName)
	{
		return (ds_list_find_index(animation_names, _animationName) > -1);
	}
	
	static GetActiveAnimationName = function()
	{
		var animName = undefined;
		with (instance_ref)
		{
			animName = skeleton_animation_get();
		}
		return animName;
	}
	
	static GetActiveAnimationDuration = function()
	{
		var animDuration = -1;
		var animName = GetActiveAnimationName();
		with (instance_ref)
		{
			animDuration = skeleton_animation_get_duration(animName);
		}
		// RETURN VALUE IN MILLISECONDS
		return animDuration * 1000;
	}
	
	static GetActiveAnimationFrame = function()
	{
		var animFrame = -1;
		with (instance_ref)
		{
			animFrame = floor(skeleton_animation_get_frame(0));
		}
		return animFrame;
	}
	
	static GetActiveAnimationFrameCount = function()
	{
		var animFrameCount = -1;
		var animName = GetActiveAnimationName();
		with (instance_ref)
		{
			animFrameCount = skeleton_animation_get_frames(animName);
		}
		return animFrameCount;
	}
	
	static GetActiveAnimationPosition = function(_trackIndex = 0)
	{
		var animPosition = 0;
		with (instance_ref)
		{
			animPosition = skeleton_animation_get_position(_trackIndex);
		}
		return animPosition;
	}
	
	static Draw = function()
	{
		CheckActiveAnimationEventFrames(ev_draw);
	}
	
	static DrawEnd = function()
	{
		// OVERRIDE THIS FUNCTION
	}
}