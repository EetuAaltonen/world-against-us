if (!isCameraCreated)
{
	if (cameraTarget == noone)
	{
		if (instance_exists(objPlayer))
		{
			cameraTarget = instance_find(objPlayer, 0);
		}
	} else {
		view_camera[0] = camera_create_view(
			0, 0, view_wport[0], view_hport[0],
			0, noone/*isCameraCreated*/, -1, -1, 400, 250
		);
		
		isCameraCreated = true;
	}
}
