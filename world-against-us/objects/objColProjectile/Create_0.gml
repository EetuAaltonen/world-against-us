// INHERIT THE PARENT EVENT
event_inherited();

// PROJECTILE PROPERTIES
speed = 0;
flySpeed = 0;
directionalSpeedVector = undefined;

// INIT COLLIDER
collider = new Collider(COLLIDER_TYPE.Point);

// COLLISION CHECK
collisionObjects = [objCharacterParent, objBlockParent];
isTargetHit = false;
collisionTarget = noone;
hitIgnoreInstance = noone;

// TODO: Fix projectile trail logic
//projectileTrailWidth = 2;
//traceTailPosition = new Vector2(x, y);
//traceTailStep = new Vector2(0, 0);
//aimAngleLine = undefined;
// TODO: Fix bullet hole logic
//bulletHoleRadius = 4;
// TODO: Fix bullet hole timer
//bulletHoleDuration = 5000;