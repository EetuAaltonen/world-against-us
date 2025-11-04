function SkeletalAnimationPlaybackCharacterRifleReload(_animationRef, _animatorRef)
{
	_animationRef.current_frame += _animationRef.animation_speed;
	
	if (_animationRef.current_frame >= _animationRef.animation_data.frame_count)
	{
		// RESET ANIMATION VIA RESETTING CHARACTER ACTION
		_animatorRef.instance_ref.character.action_handler.ResetAction();
	}
}