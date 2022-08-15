// INHERITED EVENT
event_inherited();
character = new Character("Player", CHARACTER_TYPE.PLAYER);

image_index = 0;
image_speed = 0;

acceleration = 1;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 10;

// SPAWN GUN
gun = instance_create_layer(x, y, "Equipment", objGun);
gun.owner = self;

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
ResetPlayerMovementValues();
ResetPlayerInputValues();
