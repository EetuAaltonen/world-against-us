// INHERIT THE PARENT EVENT
event_inherited();

// STOP ANIMATION
image_speed = 0;

// SKELETAL ANIMATION
var defaultAnimations = [
	// TRACK 0 - UPPER BODY
	new SkeletalActiveAnimation(
		sprite_index, CHARACTER_ANIM_RIFLE_AIM,
		0, SKELETAL_ANIM_SKIN_UPPERBODY, 1, false, true
	),
	// TRACK 1 - LOWER BODY
	new SkeletalActiveAnimation(
		sprite_index, CHARACTER_ANIM_WALK,
		1, SKELETAL_ANIM_SKIN_LOWERBODY, 1, true, false
	)
];
skeletalAnimator = new SkeletalAnimator(self, defaultAnimations);

// INIT COLLIDER AND COLLISION BODY
var collisionBody = new CollisionBody(
	COLLISION_BODY_TYPE.Humanoid
);
collider = new Collider(
	COLLIDER_TYPE.Circle,
	sprite_width * 0.5, 
	-(bbox_bottom - bbox_top) * 0.5,
	collisionBody
);

baseAcceleration = 0.15;
acceleration = baseAcceleration;
baseMaxSpeed = 2.5;
maxSpeed = baseMaxSpeed;

// CONTROLS
inputDeviceMovement = new InputDeviceMovement(true); // ENABLE INPUT HISTORY
inputDeviceMouse = new InputDeviceMouse();

// NETWORKING
previousPosition = new Vector2(0, 0);

// DEBUG AUTOPILOT BOT
autopilotMode = false;
autopilotInputTimer = new Timer(500);