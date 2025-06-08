function SkeletalAnimationSkin(_instanceRef) constructor
{
	instance_ref = _instanceRef;
	skin_list = ds_list_create();
	
	InitSkinList();
	
	static OnDestroy = function()
	{
		ReleaseVariableFromMemory(skin_list, ds_type_list);
		skin_list = undefined;
	}
	
	static InitSkinList = function()
	{
		with (instance_ref)
		{
			skeleton_skin_list(sprite_index, other.skin_list);
		}
	}
	
	static SetSkin = function(_skinName)
	{
		if (ds_list_find_index(skin_list, _skinName) > -1)
		{
			with (instance_ref)
			{
				skeleton_skin_set(_skinName);
			}
		}
	}
}