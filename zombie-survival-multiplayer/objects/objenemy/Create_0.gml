// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Zombie", CHARACTER_TYPE.HOSTILE, CHARACTER_RACE.humanoid);

acceleration = 1;
hSpeed = 0;
vSpeed = 0;
dirSpeed = 0;
maxSpeed = 1;

// PATH FINDING
pathToTarget = path_add();
pathUpdateInterval = TimerFromSeconds(0.5);
pathUpdateTimer = new Timer(pathUpdateInterval);

// TARGET
targetSeekInterval = TimerFromSeconds(4);
targetSeekTimer = new Timer(targetSeekInterval);
targetSeekTimer.StartTimer();

targetInstance = noone;
targetPosition = new Vector2(x, y);

// SENSES
visionRadius = MetersToPixels(10);