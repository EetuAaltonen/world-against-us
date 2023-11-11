// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Bandit", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.HOSTILE);

maxSpeed = 5;

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