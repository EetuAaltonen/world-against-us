function SkeletalActiveAnimation(_animatorRef, _animationName, _animationSkin, _animationSpeed, _isLooping, _isSyncWithInstance) constructor
{
	animator_ref = _animatorRef;
	animation_name = _animationName;
	animation_skin = _animationSkin;
	animation_speed = _animationSpeed;
	is_looping = _isLooping;
	is_sync_with_instance = _isSyncWithInstance;
	
	animation_data = undefined;
	current_frame = 0;
	
	Initialize();
	
	static Initialize = function()
	{
		var spriteName = sprite_get_name(animator_ref.instance_ref.sprite_index);
		var skeletalSpriteData = global.SkeletalSpriteDatabase[? spriteName];
		animation_data = skeletalSpriteData.animations[? animation_name];
	}
	
	static CheckActiveAnimationEventFrames = function()
	{
		// TODO: Fix this logic
		/*var activeAnimationEvents = animation_events[? active_animation_name];
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
		}*/
	}
	
	static Draw = function(_instanceRef)
	{
		if (!is_undefined(animation_data.playback_function))
		{
			animation_data.playback_function(self, animator_ref);
		}
		
		if (is_looping)
		{
			if (current_frame > animation_data.frame_count) { current_frame = 0; }
			if (current_frame < 0) { current_frame = animation_data.frame_count; }
		} else {
			current_frame = max(current_frame, 0.001);
			current_frame = min(current_frame, animation_data.frame_count - 0.001);
		}

		if (is_sync_with_instance)
		{
			with (_instanceRef)
			{
				skeleton_animation_set_frame(0, other.current_frame);
			}
		}
		
		if (!is_undefined(animation_data.draw_function))
		{
			animation_data.draw_function(self, animator_ref);
		} else {
			SkeletalAnimationDraw(self, animator_ref);
		}
		
		CheckActiveAnimationEventFrames();
	}
}