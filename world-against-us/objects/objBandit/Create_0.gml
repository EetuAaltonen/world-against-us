// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Bandit", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.HOSTILE);

maxSpeed = 5;

// AI
aiState = AI_STATE.QUEUE;

// PATH
patrolPath = undefined;
patrolPathPercent = undefined;
patrolPathLastPosition = undefined;
pathToTarget = path_add();
chasePathUpdateInterval = TimerFromSeconds(0.5);
chasePathUpdateTimer = new Timer(chasePathUpdateInterval);
pathBlockingRadius = 20;

targetPath = undefined;

// TARGET
targetSearchInterval = TimerFromSeconds(2);
targetSearchTimer = new Timer(targetSearchInterval);
targetSearchTimer.StartTimer();

targetInstance = noone;
targetPosition = new Vector2(x, y);

// VISION
visionRadius = MetersToPixels(20);