// INHERIT THE PARENT EVENT
event_inherited();

// STOP ANIMATION
image_speed = 0;

// SKELETAL ANIMATION
skeletalAnimator = new SkeletalAnimator(self);
skeletalAnimator.SetSkeletonSkin("empty");
// SET DEFAULT RIFLE AIM ANIMATION
var activeAnimation = new SkeletalActiveAnimation(
	skeletalAnimator, "rifle_aim", 0, "upperbody", 1, false, true
);
skeletalAnimator.SetActiveAnimation(activeAnimation);
// SET DEFAULT WALK ANIMATION
var activeAnimation = new SkeletalActiveAnimation(
	skeletalAnimator, "walk", 1, "lowerbody", 1, true, false
);
skeletalAnimator.SetActiveAnimation(activeAnimation);


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
movementInput = new DeviceInputMovement(0, 0, 0, 0);
prevMovementInput = new DeviceInputMovement(0, 0, 0, 0);

// NETWORKING
previousPosition = new Vector2(0, 0);

// DEBUG AUTOPILOT BOT
autopilotMode = false;
autopilotInputTimer = new Timer(500);