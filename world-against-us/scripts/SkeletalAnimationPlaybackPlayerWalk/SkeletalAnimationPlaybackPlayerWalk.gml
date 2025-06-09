function SkeletalAnimationPlaybackPlayerWalk(_animationRef, _animatorRef)
{
	var instanceRef = _animatorRef.instance_ref;
	if (instanceRef.dirSpeed.h_speed != 0 ||
		instanceRef.dirSpeed.v_speed != 0)
	{
		var isAnimationReversed = (
			sign(instanceRef.image_xscale) != sign(instanceRef.dirSpeed.h_speed) &&
			abs(instanceRef.dirSpeed.h_speed)
		);
		_animationRef.current_frame += (!isAnimationReversed) ? _animationRef.animation_speed : -_animationRef.animation_speed;
	}
}