function CharacterChangePosture(_instanceRef, _postureIndex)
{
	var isPostureChanged = false;
	if (is_undefined(_instanceRef)) return isPostureChanged;
	var characterRef = _instanceRef.character;
	if (is_undefined(characterRef)) return isPostureChanged;
	var skeletalAnimatorRef = _instanceRef.skeletalAnimator;
	if (is_undefined(skeletalAnimatorRef)) return isPostureChanged;
	
	if (characterRef.posture != _postureIndex)
	{
		switch (_postureIndex)
		{
			case CHARACTER_POSTURE_HUMAN.CROUCH:
			{
				var upperbodyAnimation = new SkeletalActiveAnimation(
					skeletalAnimatorRef, CHARACTER_ANIM_CROUCH,
					0, SKELETAL_ANIM_SKIN_UPPERBODY, 1, false, true
				);
				skeletalAnimatorRef.SetActiveAnimation(upperbodyAnimation);
				var lowerbodyAnimation = new SkeletalActiveAnimation(
					skeletalAnimatorRef, CHARACTER_ANIM_CROUCH,
					1, SKELETAL_ANIM_SKIN_LOWERBODY, 1, true, false
				);
				skeletalAnimatorRef.SetActiveAnimation(lowerbodyAnimation);
				
				characterRef.posture = _postureIndex;
				isPostureChanged = true;
			} break;
			default:
			{
				// UNHANDLED POSTURE MODIFIER
			}
		}
	} else {
		var upperbodyAnimation = new SkeletalActiveAnimation(
			skeletalAnimatorRef, CHARACTER_ANIM_RIFLE_AIM,
			0, SKELETAL_ANIM_SKIN_UPPERBODY, 1, false, true
		);
		skeletalAnimatorRef.SetActiveAnimation(upperbodyAnimation);
		var lowerbodyAnimation = new SkeletalActiveAnimation(
			skeletalAnimatorRef, CHARACTER_ANIM_WALK,
			1, SKELETAL_ANIM_SKIN_LOWERBODY, 1, true, false
		);
		skeletalAnimatorRef.SetActiveAnimation(lowerbodyAnimation);
		
		characterRef.posture = characterRef.default_posture;
	}
}