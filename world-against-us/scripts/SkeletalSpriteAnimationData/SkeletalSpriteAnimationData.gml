function SkeletalSpriteAnimationData(_name, _events, _playbackFunction, _drawFunction) constructor
{
	name = _name;
	events = _events;
	playback_function = _playbackFunction;
	draw_function = _drawFunction;
	frame_count = -1;
	is_initialized = false;
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.events, ds_type_map);
		_struct.events = undefined;
	}
	
	static Initialize = function(_instanceRef)
	{
		if (!is_initialized)
		{
			with (_instanceRef)
			{
				other.frame_count = skeleton_animation_get_frames(other.name);
			}
			
			// POPULATE INSTANCE-RELATED SKELETON SPRITE ANIMATION EVENT DATA INTO DATABASE ON INITIALIZE
			var eventIndices = ds_map_keys_to_array(events);
			var eventCount = array_length(eventIndices);
			for (var i = 0; i < eventCount; i++)
			{
				var event = events[? eventIndices[@ i]];
				event.Initialize(_instanceRef, name);
			}
		}
		is_initialized = true;
	}
}