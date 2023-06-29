// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Zombie", CHARACTER_TYPE.HOSTILE, CHARACTER_RACE.humanoid);

acceleration = 1;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 1;

// PATH FINDING
path = path_add();
updatePath = false;
pathUpdateDelay = TimerFromSeconds(1);//TimerFromSeconds(4);
pathUpdateTimer = pathUpdateDelay;

// TARGET
targetPosition = new Vector2(x, y);
lastKnownTargetPos = new Vector2(x, y);
aggroRadius = 1280;
stopRadius = 10;//128;