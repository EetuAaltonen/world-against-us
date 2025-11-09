function SkeletalAnimationSkeleton(_instanceRef) constructor
{
	instance_ref = _instanceRef;
	bone_names = ds_list_create();
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.bone_names, ds_type_list);
		_struct.bone_names = undefined;
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			with (instance_ref)
			{
				skeleton_bone_list(sprite_index, other.bone_names);
			}
		}
		is_initialized = true;
	}
	
	static GetBoneDataByName = function(_boneName, _mapRef)
	{
		with (instance_ref)
		{
			skeleton_bone_state_get(_boneName, _mapRef);
		}
	}
}