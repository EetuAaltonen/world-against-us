function SkeletalAnimationPlaybackPlayerWalk(_animationSliceGroupRef, _animationSkeletalRef)
{
	var instanceRef = _animationSkeletalRef.instance_ref;
	if (instanceRef.dirSpeed.h_speed != 0 ||
		instanceRef.dirSpeed.v_speed != 0)
	{
		var isAnimationReversed = (
			sign(instanceRef.image_xscale) != sign(instanceRef.dirSpeed.h_speed) &&
			abs(instanceRef.dirSpeed.h_speed)
		);
		_animationSliceGroupRef.current_frame += (!isAnimationReversed) ? 1 : -1;
		if (_animationSliceGroupRef.current_frame > _animationSliceGroupRef.frame_count) { _animationSliceGroupRef.current_frame = 0; }
		if (_animationSliceGroupRef.current_frame < 0) { _animationSliceGroupRef.current_frame = _animationSliceGroupRef.frame_count; }
	}
}