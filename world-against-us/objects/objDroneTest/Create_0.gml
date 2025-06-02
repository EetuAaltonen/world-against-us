// INHERIT THE PARENT EVENT
event_inherited();

z = 80;
//image_speed = 0;

// SKELETAL ANIMATION
skeletalAnimationEvents = ds_map_create();
ds_map_add(
	skeletalAnimationEvents, "animation1",
	[
		new SkeletalAnimationEvent(ev_draw, "draw_color_random", function(_instanceRef) {
			_instanceRef.image_blend = make_color_rgb(random(255), random(255), random(255));
		}),
		new SkeletalAnimationEvent(ev_draw, "draw_color_reset", function(_instanceRef) {
			_instanceRef.image_blend = -1;
		})
	]
);
skeletalAnimation = new SkeletalAnimation(self, skeletalAnimationEvents);
skeletalAnimation.SetAnimation("animation1", 1, true);

// INIT COLLIDER AND COLLISION BODY
var collisionBody = new CollisionBody(
	COLLISION_BODY_TYPE.Full_sprite
);
collider = new Collider(
	COLLIDER_TYPE.Circle,
	32, 0, collisionBody
);