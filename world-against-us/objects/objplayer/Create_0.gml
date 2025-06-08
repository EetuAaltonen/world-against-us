// INHERIT THE PARENT EVENT
event_inherited();

// STOP ANIMATION
image_speed = 0;

// SKELETAL ANIMATION
var skeletalAnimationEvents = ds_map_create();
var skeletalAnimationSliceGroups = ds_list_create();
ds_list_add(skeletalAnimationSliceGroups, new SkeletalAnimationSliceGroup(self, "rifle_aim", "upperbody", SkeletalAnimationPlaybackPlayerRifleAim));
ds_list_add(skeletalAnimationSliceGroups, new SkeletalAnimationSliceGroup(self, "walk", "lowerbody", SkeletalAnimationPlaybackPlayerWalk));

skeletalAnimation = new SkeletalAnimationSlice(self, skeletalAnimationEvents, skeletalAnimationSliceGroups);
skeletalAnimation.SetAnimation("rifle_aim", 1, true);

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

baseAcceleration = 0.25;
acceleration = baseAcceleration;
baseMaxSpeed = 2.5;
maxSpeed = baseMaxSpeed;

// CONTROLS
movementInput = new DeviceInputMovement(0, 0, 0, 0);
prevMovementInput = new DeviceInputMovement(0, 0, 0, 0);

// EQUIPMENT POSITIONS
equipmentOriginOffset = new Vector2(0, -88);

// SPAWN WEAPON
// TODO: Move the weapon under character struct
//weapon = instance_create_depth(x, y, depth - 1, objWeapon);
//weapon.owner = self;

// NETWORKING
previousPosition = new Vector2(0, 0);

// DEBUG AUTOPILOT BOT
autopilotMode = false;
autopilotInputTimer = new Timer(500);