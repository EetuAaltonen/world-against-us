// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index) return;

if (isHit)
{
	bulletTraceLengthScale -= 1 / (point_distance(x, y, bulletTraceVector.X, bulletTraceVector.Y) / flySpeed);
	if (bulletTraceLengthScale <= 0) instance_destroy();
} else {
	bulletTraceVector.X = x - damageSource.spawn_point.X;
	bulletTraceVector.Y = y - damageSource.spawn_point.Y;
}