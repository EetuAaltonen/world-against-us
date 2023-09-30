// INHERIT THE PARENT EVENT
event_inherited();

character = undefined;

image_index = 0;
image_speed = 0;

acceleration = 0.15;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 2.5;

// SPAWN WEAPON
// TODO: Move the weapon under character struct
weapon = instance_create_depth(x, y, depth - 1, objWeapon);
weapon.owner = self;

// NETWORKING
// TODO: Move this under objPlayerManager
syncTimer = new Timer(TimerFromMilliseconds(100));

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

// NETWORKING VALUE MONITORING
ResetPlayerPositionValues();
ResetPlayerVelocityValues();
ResetPlayerInputValues();
