// INHERIT THE PARENT EVENT
event_inherited();

// DEFAULT INSTANCE PROPERTIES
image_speed = 0;
speed = 0;

// PROJECTILE PROPERTIES
flySpeed = 0;
directionalSpeedVector = undefined;

// INIT COLLIDER
collider = new Collider(COLLIDER_TYPE.Point);

// COLLISION CHECK
collisionObjects = [objCharacterParent, objBlockParent];
collisionTarget = noone;
hitIgnoreInstance = noone;
isHit = false;

// BULLET TRACE
bulletTraceVector = undefined;
bulletTraceMaxLength = 0;
bulletTraceLengthScale = 1;
bulletTraceWidth = 3;