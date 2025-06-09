function SkeletalAnimationDraw(_animationRef, _animatorRef)
{
	var instanceRef = _animatorRef.instance_ref;
	draw_skeleton(
		instanceRef.sprite_index, _animationRef.animation_name, _animationRef.animation_skin,
		_animationRef.current_frame, instanceRef.x, instanceRef.y - instanceRef.z, 
		instanceRef.image_xscale, instanceRef.image_yscale,
		instanceRef.image_angle, c_orange, instanceRef.image_alpha
	);
}