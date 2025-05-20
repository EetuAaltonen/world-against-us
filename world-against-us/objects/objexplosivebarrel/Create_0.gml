// INHERIT THE PARENT EVENT
event_inherited();

// INIT COLLIDER
collider = new Collider(
	COLLIDER_TYPE.Bounding_box,
	0, 0, undefined
);

damage = 100;
blastRadius = 300;
blastRadiusStep = (blastRadius * 0.05);