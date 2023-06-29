// INHERIT THE PARENT EVENT
event_inherited();

image_speed = 0;
speed = 0;
flySpeed = 100;
projectileTrailWidth = 2;
initSpeed = true;

bullet = undefined;
// TODO: Fix bullet hole logic
//bulletHoleRadius = 4;
//bulletHoleDuration = TimerFromSeconds(5);

traceTailPosition = new Vector2(x, y);
traceTailStep = new Vector2(0, 0);

objectsToHit = [objCharacterParent, objBlockParent];
isHit = false;