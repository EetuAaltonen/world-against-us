if (blastInstance == noone)
{
	blastInstance = instance_create_layer(x, y, "Projectiles", objExplosiveBlast);
	blastInstance.damage = damage;
}
