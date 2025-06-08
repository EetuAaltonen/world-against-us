function SkeletalAnimationSkeleton(_instanceRef) constructor
{
	instance_ref = _instanceRef;
	bone_names = ds_list_create();
	GetBoneNames(bone_names);
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(bone_names, ds_type_list);
		bone_names = undefined;
	}
	
	static GetBoneNames = function(_listRef)
	{
		with (instance_ref)
		{
			skeleton_bone_list(sprite_index, _listRef);
		}
	}
	
	static GetBoneDataByName = function(_boneName, _mapRef)
	{
		with (instance_ref)
		{
			skeleton_bone_state_get(_boneName, _mapRef);
		}
	}
}