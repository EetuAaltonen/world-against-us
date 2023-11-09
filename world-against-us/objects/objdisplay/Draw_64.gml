// DEBUG FPS
if (global.DEBUGMODE)
{
	draw_set_color(c_yellow);
	draw_text(32, 32, "FPS real: " + string(fpsReal));
	draw_text(32, 64, "FPS: " + string(_fps));

	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}

// NETWORKING INFO
draw_set_font(font_small_bold);
draw_set_color(c_red);
draw_set_halign(fa_right);
		
draw_text(global.GUIW - 20, 10, string("{0} :Status", global.MultiplayerMode ? "Online" : "Offline"));

if (global.MultiplayerMode)
{
	if (!is_undefined(global.NetworkHandlerRef.socket))
	{
		if (global.NetworkHandlerRef.client_id != UNDEFINED_UUID)
		{
			draw_text(global.GUIW - 20, 30, string("{0} :client_id", global.NetworkHandlerRef.client_id));
			draw_text(global.GUIW - 20, 50, string("{0} :Region ID", global.NetworkRegionHandlerRef.region_id ?? "Unknown"));
			draw_text(global.GUIW - 20, 70, string("{0} :Prev region ID", global.NetworkRegionHandlerRef.prev_region_id ?? "Unknown"));
			draw_text(global.GUIW - 20, 90, string("{0} :Room index", global.NetworkRegionHandlerRef.room_index ?? "Unknown"));
			var ownerClientID = (global.NetworkRegionHandlerRef.owner_client ?? "Unknown");
			draw_text(global.GUIW - 20, 1100, string("{0} :Region Owner", (global.NetworkHandlerRef.client_id == ownerClientID) ? "Self" : "Other"));
		}
	}
}
		
// RESET DRAW PROPERTIES
ResetDrawProperties();