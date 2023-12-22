// INHERIT THE PARENT EVENT
event_inherited();

character = undefined;

image_index = 0;
image_speed = 0;

baseAcceleration = 0.15;
acceleration = baseAcceleration;
baseMaxSpeed = 2.5;
maxSpeed = baseMaxSpeed;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;

// SPAWN WEAPON
// TODO: Move the weapon under character struct
weapon = instance_create_depth(x, y, depth - 1, objWeapon);
weapon.owner = self;

// NETWORKING
previousPosition = new Vector2(0, 0);
positionSyncTImer = new Timer(TimerFromMilliseconds(250));

// COOP PLAYER
startLocation = new Vector2(x, y);
targetLocation = undefined;
lerpDuration = 0;
timeElapsed = 0;
tick_time = 0;
local_tick_time = 0;

// CONTROLS
key_up = 0;
key_down = 0;
key_left = 0;
key_right = 0;
