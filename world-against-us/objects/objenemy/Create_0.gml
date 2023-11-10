// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Zombie", CHARACTER_TYPE.Zombie, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.HOSTILE);

acceleration = 1;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 2;

// PATH FINDING
pathToTarget = path_add();
pathUpdateInterval = TimerFromSeconds(0.25);
pathUpdateTimer = new Timer(pathUpdateInterval);
pathBlockingRadius = 20;

// TARGET
targetSearchInterval = TimerFromSeconds(2);
targetSearchTimer = new Timer(targetSearchInterval);
targetSearchTimer.StartTimer();

targetInstance = noone;
targetPosition = new Vector2(x, y);

// SENSES
visionRadius = MetersToPixels(10);