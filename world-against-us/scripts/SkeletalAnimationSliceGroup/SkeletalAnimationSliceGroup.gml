function SkeletalAnimationSliceGroup(_instanceRef, _animName, _animSkinName, _playbackFunc) constructor
{
	instance_ref = _instanceRef;
	animation_name = _animName;
	animation_skin_name = _animSkinName;
	playback_function = _playbackFunc;
	current_frame = 0;
	frame_count = 0;
	
	with (instance_ref)
	{
		other.frame_count = skeleton_animation_get_frames(other.animation_name);
	}
}