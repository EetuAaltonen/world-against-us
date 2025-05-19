// INHERIT THE PARENT EVENT
event_inherited();

if (instanceState < INSTANCE_INIT_STATE.Done)
{
	instanceState = INSTANCE_INIT_STATE.Done;
}