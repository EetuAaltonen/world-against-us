function CharacterTogglePosture(_instanceRef, _postureIndex)
{
	var isPostureToggled = false;
	if (is_undefined(_instanceRef)) return isPostureToggled;
	var characterRef = _instanceRef.character;
	if (is_undefined(characterRef)) return isPostureToggled;
	var skeletalAnimatorRef = _instanceRef.skeletalAnimator;
	if (is_undefined(skeletalAnimatorRef)) return isPostureToggled;
	
	if (characterRef.posture != _postureIndex)
	{
		switch (_postureIndex)
		{
			case CHARACTER_POSTURE_HUMAN.CROUCH:
			{
				var upperbodyAnimation = new SkeletalActiveAnimation(
					_instanceRef.sprite_index, CHARACTER_ANIM_CROUCH,
					0, SKELETAL_ANIM_SKIN_UPPERBODY, 1, false, true
				);
				skeletalAnimatorRef.SetActiveAnimation(upperbodyAnimation);
				var lowerbodyAnimation = new SkeletalActiveAnimation(
					_instanceRef.sprite_index, CHARACTER_ANIM_CROUCH,
					1, SKELETAL_ANIM_SKIN_LOWERBODY, 1, true, false
				);
				skeletalAnimatorRef.SetActiveAnimation(lowerbodyAnimation);
				
				characterRef.posture = _postureIndex;
				isPostureToggled = true;
			} break;
			default:
			{
				// UNHANDLED POSTURE MODIFIER
				global.ConsoleHandlerRef.AddConsoleLog(
					CONSOLE_LOG_TYPE.ERROR,
					string("Unhandled posture modifier with index '{0}'", _postureIndex)
				);
			}
		}
	} else {
		// RESET DEFAULT ANIMATION
		skeletalAnimatorRef.ResetActiveAnimation();
		// RESET DEFAULT POSTURE
		characterRef.posture = characterRef.default_posture;
		isPostureToggled = true;
	}
	
	return isPostureToggled;
}