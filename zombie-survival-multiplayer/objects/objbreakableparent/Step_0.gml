// Inherit the parent event
event_inherited();

if (damageDelayTimer > 0)
{
	damageDelayTimer = max(0, --damageDelayTimer);
}