// INHERIT THE PARENT EVENT
event_inherited();

if (instanceState < INSTANCE_INIT_STATE.ParentInit)
{
	instanceState = INSTANCE_INIT_STATE.ParentInit;
}