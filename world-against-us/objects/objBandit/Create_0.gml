// INHERIT THE PARENT EVENT
event_inherited();

character = new Character("Bandit", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOUR.HOSTILE);

maxSpeed = 5;

// AI
patrolId = undefined;
aiState = AI_STATE.TRAVEL;
initPath = true;

// PATH
patrolPath = undefined;
patrolPathPercent = -1;
patrolPathLastPosition = undefined;
pathToTarget = path_add();
chasePathUpdateTimer = new Timer(500);
pathBlockingRadius = 20;

targetPath = undefined;

// TARGET
targetSearchTimer = new Timer(2000);
targetSearchTimer.StartTimer();

targetInstance = noone;
targetPosition = new Vector2(x, y);

// VISION
visionRadius = MetersToPixels(20);