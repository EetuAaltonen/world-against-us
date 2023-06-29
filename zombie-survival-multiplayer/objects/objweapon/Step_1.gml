// INHERIT THE PARENT EVENT
event_inherited();

if (instance_exists(owner))
{
	depth = owner.depth - 1;
}