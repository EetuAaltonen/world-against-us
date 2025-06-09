function SkeletalAnimator(_instanceRef) constructor
{
	instance_ref = _instanceRef;
	skeleton_sprite_data_ref = undefined;
	animation_skeleton = new SkeletalAnimationSkeleton(instance_ref);
	active_animations = ds_map_create();
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
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			// POPULATE INSTANCE-RELATED SKELETON ANIMATION DATA INTO DATABASE ON INITIALIZE
			var spriteName = sprite_get_name(instance_ref.sprite_index);
			skeleton_sprite_data_ref = global.SkeletalSpriteDatabase[? spriteName];
			if (!is_undefined(skeleton_sprite_data_ref))
			{
				skeleton_sprite_data_ref.Initialize(instance_ref);
			}
		}
		is_initialized = true;
	}
	
	static SetActiveAnimation = function(_animationName, _skin, _animationSpeed, _isLooping, _isSyncWithInstance)
	{
		if (_isSyncWithInstance)
		{
			with (instance_ref)
			{
				skeleton_animation_set(_animationName, _isLooping);
				skeleton_skin_set(_skin);
				image_speed = _animationSpeed;
			}
		}
		
		var activeAnimation = new SkeletalActiveAnimation(
			self, _animationName, _skin, _animationSpeed, _isLooping, _isSyncWithInstance
		);
		ds_map_add(active_animations, _animationName, activeAnimation);
	}
	
	static RemoveActiveAnimation = function(_animationName)
	{
		var animation = active_animations[_animationName];
		ReleaseVariableFromMemory(animation);
		ds_map_delete(active_animations, _animationName);
	}
	
	static ClearActiveAnimations = function()
	{
		ClearDSMapAndDeleteValues(active_animations);
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
		var activeAnimationIndices = ds_map_keys_to_array(active_animations);
		var activeAnimationCount = array_length(activeAnimationIndices);
		for (var i = 0; i < activeAnimationCount; i++)
		{
			var activeAnimation = active_animations[? activeAnimationIndices[@ i]];
			activeAnimation.Draw(instance_ref);
		}
	}
}