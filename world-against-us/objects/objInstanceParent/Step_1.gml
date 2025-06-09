// INITIALIZE INSTANCE
if (instanceState != object_index)
{
	instanceState = event_object;
	if (isInstanceStateRootEventCalledOnce)
	{
		throw(string("Failed to initialize instance state of an object: {0}", object_get_name(object_index)));
	}
	isInstanceStateRootEventCalledOnce = true;
}

depth = -y;