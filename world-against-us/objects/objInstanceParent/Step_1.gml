// INITIALIZE INSTANCE
if (instanceState < INSTANCE_INIT_STATE.InstanceInit)
{
	// TODO: Optimize hitboxes
	//InitializeHitbox(self);
	
	instanceState = INSTANCE_INIT_STATE.InstanceInit;
}

depth = -(bbox_bottom);
isInCameraView = true;