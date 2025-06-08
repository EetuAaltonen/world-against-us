// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Zombie", CHARACTER_TYPE.Zombie, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOR.HOSTILE);

acceleration = 1;
maxSpeed = 2;

// PATH FINDING
pathToTarget = path_add();
pathUpdateTimer = new Timer(250);
pathBlockingRadius = 20;

// TARGET
targetSearchTimer = new Timer(2000);
targetSearchTimer.StartTimer();

targetInstance = noone;
targetPosition = new Vector2(x, y);

// SENSES
visionRadius = MetersToPixels(10);