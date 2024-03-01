// INHERIT THE PARENT EVENT
event_inherited();

image_index = 0;
image_speed = 0;

baseAcceleration = 0.15;
acceleration = baseAcceleration;
baseMaxSpeed = 2.5;
maxSpeed = baseMaxSpeed;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;

// CONTROLS
movementInput = new DeviceInputMovement(0, 0, 0, 0);
prevMovementInput = new DeviceInputMovement(0, 0, 0, 0);

// SPAWN WEAPON
// TODO: Move the weapon under character struct
//weapon = instance_create_depth(x, y, depth - 1, objWeapon);
//weapon.owner = self;

// NETWORKING
previousPosition = new Vector2(0, 0);
positionSyncTImer = new Timer(200);
// DEBUG AUTOPILOT BOT
autopilotMode = false;
autopilotInputTimer = new Timer(500);