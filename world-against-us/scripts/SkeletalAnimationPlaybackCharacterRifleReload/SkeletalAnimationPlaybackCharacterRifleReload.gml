function SkeletalAnimationPlaybackCharacterRifleReload(_animationRef, _animatorRef)
{
	_animationRef.current_frame += _animationRef.animation_speed;
	
	if (_animationRef.current_frame >= _animationRef.animation_data.frame_count)
	{
		// RESET CHARACTER ACTION
		_animatorRef.instance_ref.character.action_handler.ResetAction();
		
		// SET CHARACTER ANIMATION TO PREVIOUSLY ACTIVE
		var prevActiveAnimation = _animatorRef.prev_active_animations[? _animationRef.animation_track];
		if (!is_undefined(prevActiveAnimation))
		{
			_animatorRef.SetActiveAnimation(
				prevActiveAnimation.animation_name, prevActiveAnimation.animation_track,
				prevActiveAnimation.animation_skin, prevActiveAnimation.animation_speed,
				prevActiveAnimation.is_looping, prevActiveAnimation.is_sync_with_instance
			);
		}
	}
}