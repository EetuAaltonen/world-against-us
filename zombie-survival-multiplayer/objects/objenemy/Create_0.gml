// INHERITED EVENT
event_inherited();
character = new Character("Zombie", CHARACTER_TYPE.HOSTILE);

acceleration = 1;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 6;

// PATH FINDING
path = path_add();
updatePath = false;
pathUpdateDelay = TimerFromSeconds(4);
pathUpdateTimer = pathUpdateDelay;

// TARGET
lastKnownTargetPos = new Vector2(x, y);
aggroRadius = 1280;
stopRadius = 128;