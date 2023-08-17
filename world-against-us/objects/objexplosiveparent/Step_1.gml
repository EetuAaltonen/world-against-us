// INHERIT THE PARENT EVENT
event_inherited();

if (blastInstance == noone)
{
	blastInstance = instance_create_depth(x, y, 0, objExplosiveBlast);
	blastInstance.damage = damage;
}
