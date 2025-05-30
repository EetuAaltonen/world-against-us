// DESTROY SKELETAL ANIMATION
DestroyDSMapAndDeleteValues(skeletalAnimationEvents);
skeletalAnimationEvents = undefined;

DeleteStruct(skeletalAnimation);
skeletalAnimation = undefined;

// DESTROY COLLIDER
DeleteStruct(collider);
collider = undefined;