function SkeletalSpriteData(_spriteName, _animations) constructor
{
	sprite_name = _spriteName;
	animations = _animations;
	skins = ds_list_create();
	is_initialized = false;
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.animations, ds_type_map);
		_struct.animations = undefined;
		
		ReleaseVariableFromMemory(_struct.skins, ds_type_list);
		_struct.skins = undefined;
	}
	
	static Initialize = function(_instanceRef)
	{
		if (!is_initialized)
		{
			var spriteIndex = asset_get_index(sprite_name);
			with (_instanceRef)
			{
				skeleton_skin_list(spriteIndex, other.skins);
			}
			
			// POPULATE INSTANCE-RELATED SKELETON SPRITE ANIMATION DATA INTO DATABASE ON INITIALIZE
			var animationIndices = ds_map_keys_to_array(animations);
			var animationCount = array_length(animationIndices);
			for (var i = 0; i < animationCount; i++)
			{
				var animationData = animations[? animationIndices[@ i]];
				animationData.Initialize(_instanceRef);
			}
		}
		is_initialized = true;
	}
}