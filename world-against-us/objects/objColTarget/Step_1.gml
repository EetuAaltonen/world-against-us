// INHERIT THE PARENT EVENT
event_inherited();

// INITIALIZE INSTANCE
if (instanceState < INSTANCE_INIT_STATE.Done)
{
	instanceState = INSTANCE_INIT_STATE.Done;
}