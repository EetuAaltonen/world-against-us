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
var gun = instance_create_layer(x, y, "Equipment", objGun);

// COOP PLAYER
startLocation = new Vector2(x, y);
targetLocation = new Vector2(x, y);
lerpDuration = TimerRatePerSecond(30);
timeElapsed = 0;