function SkeletalAnimator(_instanceRef, _defaultAnimations) constructor
{
	instance_ref = _instanceRef;
	skeleton_sprite_data_ref = undefined;
	default_animations = _defaultAnimations;
	active_animations = ds_map_create();
	animation_skeleton = new SkeletalAnimationSkeleton(instance_ref);
	prev_active_animations = ds_map_create();
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function(_struct = self)
	{
		// DON'T DELETE DATABASE REFERENCE DATA
		_struct.skeleton_sprite_data_ref = undefined;
		
		ReleaseVariableFromMemory(_struct.default_animations);
		_struct.default_animations = undefined;
		
		ReleaseVariableFromMemory(_struct.active_animations, ds_type_map);
		_struct.active_animations = undefined;
		
		ReleaseVariableFromMemory(_struct.prev_active_animations, ds_type_map);
		_struct.prev_active_animations = undefined;
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			// SET DEFAULT SKIN EMPTY TO MAKE SKELETAL BONES INVISIBLE
			// ANIMATIONS ARE DRAWN USING PARTIAL SKINS (UPPER AND LOWER BODY)
			SetSkeletonSkin(SKELETAL_ANIM_SKIN_EMPTY);
			// DISABLE DEFAULT SPRITE FRAMES PLAYBACK
			instance_ref.image_speed = 0;
			
			// POPULATE INSTANCE-RELATED SKELETON SPRITE DATA INTO DATABASE ON INITIALIZE
			var spriteName = sprite_get_name(instance_ref.sprite_index);
			skeleton_sprite_data_ref = global.SkeletalSpriteDatabase[? spriteName];
			if (!is_undefined(skeleton_sprite_data_ref))
			{
				skeleton_sprite_data_ref.Initialize(instance_ref);
			}
			
			// SET DEFAULT ANIMATIONS ACTIVE
			ResetActiveAnimation();
		}
		is_initialized = true;
	}
	
	static SetActiveAnimation = function(_activeAnimation)
	{
		var isAnimationSet = false;
		if (!is_undefined(skeleton_sprite_data_ref))
		{
			var skeletalSpriteAnimationData = skeleton_sprite_data_ref.animations[? _activeAnimation.animation_name];
			if (!is_undefined(skeletalSpriteAnimationData))
			{
				StorePrevActiveAnimationByTrack(_activeAnimation.animation_track);
				RemoveActiveAnimationByTrack(_activeAnimation.animation_track);
				
				with (instance_ref)
				{
					skeleton_animation_clear(_activeAnimation.animation_track);
					if (_activeAnimation.is_sync_with_instance)
					{
						skeleton_animation_set_position(_activeAnimation.animation_track, 0);
						skeleton_animation_set_ext(_activeAnimation.animation_name, _activeAnimation.animation_track, _activeAnimation.is_looping);
					}
				}
				
				ds_map_add(active_animations, _activeAnimation.animation_track, _activeAnimation);
				
				isAnimationSet = true;
			} else {
				throw(string("Attempting to set unknown skeletal sprite animation with name '{0}'", _activeAnimation.animation_name));
			}
		}
		return isAnimationSet;
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
	
	static ResetActiveAnimation = function()
	{
		if (is_array(default_animations))
		{
			var defaultAnimationCount = array_length(default_animations);
			for (var i = 0; i < defaultAnimationCount; i++)
			{
				var defaultAnimation = default_animations[@ i];
				if (!is_undefined(defaultAnimation))
				{
					// SET DEFAULT ANIMATION ACTIVE
					SetActiveAnimation(defaultAnimation);
				}
			}
		}
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
			activeAnimation.Draw(instance_ref, self);
		}
	}
}