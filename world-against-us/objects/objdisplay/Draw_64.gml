// DEBUG FPS
if (global.DEBUGMODE)
{
	draw_set_color(c_yellow);
	draw_text(32, 32, "FPS real: " + string(fpsReal));
	draw_text(32, 64, "FPS: " + string(_fps));
	
	if (global.NetworkHandlerRef.client_id != UNDEFINED_UUID)
	{
		draw_text(32, 96, "Client ID: " + string(global.NetworkHandlerRef.client_id));
	}

	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}