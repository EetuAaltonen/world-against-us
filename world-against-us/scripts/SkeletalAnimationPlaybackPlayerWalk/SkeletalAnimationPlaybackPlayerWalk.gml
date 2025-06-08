function SkeletalAnimationPlaybackPlayerWalk(_animationSliceGroupRef, _animationSkeletalRef)
{
	var instanceRef = _animationSkeletalRef.instance_ref;
	if (instanceRef.dirSpeed.hSpeed != 0 ||
		instanceRef.dirSpeed.vSpeed != 0)
	{
		if (instanceRef.dirSpeed.hSpeed > 0)
		{
			_animationSliceGroupRef.current_frame += sign(instanceRef.image_xscale);
		} else {
			_animationSliceGroupRef.current_frame -= sign(instanceRef.image_xscale);
		}

		if (_animationSliceGroupRef.current_frame > _animationSliceGroupRef.frame_count) { _animationSliceGroupRef.current_frame = 0; }
		if (_animationSliceGroupRef.current_frame < 0) { _animationSliceGroupRef.current_frame = _animationSliceGroupRef.frame_count; }
	} else {
		_animationSliceGroupRef.current_frame = 0;
	}
}