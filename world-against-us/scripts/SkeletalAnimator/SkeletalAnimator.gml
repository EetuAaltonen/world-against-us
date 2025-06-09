function SkeletalAnimator(_instanceRef) constructor
{
	instance_ref = _instanceRef;
	skeleton_sprite_data_ref = undefined;
	animation_skeleton = new SkeletalAnimationSkeleton(instance_ref);
	active_animations = ds_map_create();
	prev_active_animations = ds_map_create();
	is_initialized = false;
	
	Initialize();
	
	// STOP DEFAULT SPRITE ANIMATION
	instance_ref.image_speed = 0;
	
	static OnDestroy = function()
	{
		// DON'T DELETE DATABASE REFERENCE DATA
		skeleton_sprite_data_ref = undefined;
		
		ReleaseVariableFromMemory(active_animations, ds_type_map);
		active_animations = undefined;
		
		ReleaseVariableFromMemory(prev_active_animations, ds_type_map);
		prev_active_animations = undefined;
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			// POPULATE INSTANCE-RELATED SKELETON SPRITE DATA INTO DATABASE ON INITIALIZE
			var spriteName = sprite_get_name(instance_ref.sprite_index);
			skeleton_sprite_data_ref = global.SkeletalSpriteDatabase[? spriteName];
			if (!is_undefined(skeleton_sprite_data_ref))
			{
				skeleton_sprite_data_ref.Initialize(instance_ref);
			}
		}
		is_initialized = true;
	}
	
	static SetActiveAnimation = function(_animationName, _track, _skin, _animationSpeed, _isLooping, _isSyncWithInstance)
	{
		if (!is_undefined(skeleton_sprite_data_ref))
		{
			var skeletalSpriteAnimationData = skeleton_sprite_data_ref.animations[? _animationName];
			if (!is_undefined(skeletalSpriteAnimationData))
			{
				StorePrevActiveAnimationByTrack(_track);
				RemoveActiveAnimationByTrack(_track);
				
				with (instance_ref)
				{
					skeleton_animation_clear(_track);
					if (_isSyncWithInstance)
					{
						skeleton_animation_set_position(_track, 0);
						skeleton_animation_set_ext(_animationName, _track, _isLooping);
					}
				}

				var activeAnimation = new SkeletalActiveAnimation(
					self, _animationName, _skin, _track, _animationSpeed, _isLooping, _isSyncWithInstance
				);
				ds_map_add(active_animations, _track, activeAnimation);
			} else {
				throw(string("Attempting to set unknown skeletal sprite animation with name '{0}'", _animationName));
			}
		}
	}
	
	static GetActiveAnimationNameByTrack = function(_track)
	{
		var activeAnimationName = undefined;
		var activeAnimation = active_animations[? _track];
		if (!is_undefined(activeAnimation))
		{
			activeAnimationName = activeAnimation.animation_name;
		}
		return activeAnimationName;
	}
	
	static StorePrevActiveAnimationByTrack = function(_track)
	{
		var prevActiveAnimation = prev_active_animations[? _track];
		if (!is_undefined(prevActiveAnimation))
		{
			// DELETE ONLY WHEN OVERWRITING PREV ACTIVE ANIMATIONS
			DeleteDSMapValueByKey(prev_active_animations, _track);
		}
		
		var activeAnimation = active_animations[? _track];
		if (!is_undefined(activeAnimation))
		{
			// STORE TO PREV ACTIVE ANIMATIONS
			ds_map_add(prev_active_animations, _track, activeAnimation);
		}
	}
	
	static RemoveActiveAnimationByTrack = function(_track)
	{
		var activeAnimation = active_animations[? _track];
		if (!is_undefined(activeAnimation))
		{
			ds_map_delete(active_animations, _track);
		}
	}
	
	static SetSkeletonSkin = function(_skinName)
	{
		with (instance_ref)
		{
			skeleton_skin_set(_skinName);
		}
	}
	
	static Draw = function()
	{
		var trackIndices = ds_map_keys_to_array(active_animations);
		var trackCount = array_length(trackIndices);
		for (var i = 0; i < trackCount; i++)
		{
			var activeAnimation = active_animations[? trackIndices[@ i]];
			activeAnimation.Draw(instance_ref);
		}
	}
}