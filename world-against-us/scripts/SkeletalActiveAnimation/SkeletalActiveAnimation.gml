function SkeletalActiveAnimation(_instanceSpriteIndex, _animationName, _animationTrack, _animationSkin, _animationSpeed, _isLooping, _isSyncWithInstance) constructor
{
	animation_name = _animationName;
	animation_track = _animationTrack;
	animation_skin = _animationSkin;
	animation_speed = _animationSpeed;
	is_looping = _isLooping;
	is_sync_with_instance = _isSyncWithInstance;
	
	animation_data = undefined;
	animation_event_state = undefined;
	current_frame = 0;
	
	Initialize(_instanceSpriteIndex);
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static Initialize = function(_instanceSpriteIndex)
	{
		var spriteName = sprite_get_name(_instanceSpriteIndex);
		var skeletalSpriteData = global.SkeletalSpriteDatabase[? spriteName];
		animation_data = skeletalSpriteData.animations[? animation_name];
	}
	
	static CheckActiveAnimationEventFrames = function()
	{
		var eventIndices = ds_map_keys_to_array(animation_data.events);
		var eventCount = array_length(eventIndices);
		for (var i = 0; i < eventCount; i++)
		{
			var animationEvent = animation_data.events[? eventIndices[@ i]];
			if (!is_undefined(animationEvent))
			{
				if (array_contains(animationEvent.event_frames, current_frame))
				{
					animation_event_state = animationEvent.event_name;
				}
			}
		}
	}
	
	static Draw = function(_instanceRef, _animatorRef)
	{
		if (!is_undefined(animation_data.playback_function))
		{
			animation_data.playback_function(self, _animatorRef);
		}
		
		// UNDEFINED CURRENT FRAME VALUE INDICATES TO SKIP ANIMATION DRAWING
		// LIKE IN CASES WHERE ACTIVE ANIMATION HAS CHANGED DURING PLAYBACK FUNCTION CALL
		if (!is_undefined(current_frame))
		{
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
					skeleton_animation_set_frame(other.animation_track, other.current_frame);
				}
			}
			
			if (!is_undefined(animation_data.draw_function))
			{
				animation_data.draw_function(self, _animatorRef);
			} else {
				SkeletalAnimationDraw(self, _animatorRef);
			}
			
			CheckActiveAnimationEventFrames();
		}
	}
}