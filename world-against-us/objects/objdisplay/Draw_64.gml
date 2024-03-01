draw_set_color(c_yellow);
draw_set_font(font_small_bold);
// FPS
draw_text(12, 36, "FPS: " + string(_fps));
draw_text(12, 52, "FPS real: " + string(fpsReal));
// DEBUG FPS
if (global.DEBUGMODE)
{
	draw_text(12, 68, "DeltaTime: " + string(delta_time));
}
// RESET DRAW PROPERTIES
ResetDrawProperties();

// NETWORKING INFO
draw_set_font(font_small_bold);
draw_set_color(c_red);
draw_set_halign(fa_right);
		
draw_text(global.GUIW - 20, 10, string("({0}) {1} :Status", global.NetworkHandlerRef.network_status, global.MultiplayerMode ? "Online" : "Offline"));

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
			var ownerClientID = (global.NetworkRegionHandlerRef.owner_client == UNDEFINED_UUID) ? "Unknown" : global.NetworkRegionHandlerRef.owner_client;
			draw_text(global.GUIW - 20, 110, string("{0} :Region Owner", (global.NetworkHandlerRef.client_id == ownerClientID) ? "Self" : ownerClientID));
			draw_text(global.GUIW - 20, 130, string("{0}ms :Ping", !is_undefined(global.NetworkConnectionSamplerRef.ping) ? global.NetworkConnectionSamplerRef.ping : "-"));
			draw_text(global.GUIW - 20, 150, string("{0}kb/s :Out", BytesToKilobits(global.NetworkConnectionSamplerRef.last_data_out_rate)));
			draw_text(global.GUIW - 20, 170, string("{0}kb/s :In", BytesToKilobits(global.NetworkConnectionSamplerRef.last_data_in_rate)));
			var queuedPacketCount = ds_queue_size(global.NetworkHandlerRef.network_packet_queue);
			if (queuedPacketCount > 3)
			{
				draw_text(global.GUIW - 20, 190, string("{0}x :Queue", queuedPacketCount));
			}
		}
	}
}
// RESET DRAW PROPERTIES
ResetDrawProperties();

// CONSOLE WARNING/ERROR COUNT
if (global.ConsoleHandlerRef.GetAllConsoleLogCount() > 0)
{
	var consoleLogInfoCount = global.ConsoleHandlerRef.GetConsoleLogInfoCount();
	var consoleLogWarningCount = global.ConsoleHandlerRef.GetConsoleLogWarningCount();
	var consoleLogErrorCount = global.ConsoleHandlerRef.GetConsoleLogErrorCount();
	
	var consoleTextColor = c_white;
	var consoleIcon = sprIconInfo;
	if (consoleLogErrorCount > 0) {
		consoleIcon = sprIconError;
		consoleTextColor = global.ConsoleHandlerRef.GetConsoleTextColor(CONSOLE_LOG_TYPE.ERROR);
	} else if (consoleLogWarningCount > 0) {
		consoleIcon = sprIconWarning;
		consoleTextColor = global.ConsoleHandlerRef.GetConsoleTextColor(CONSOLE_LOG_TYPE.WARNING);
	}
	
	var iconSize = new Size(30, 30);
	var iconScale = ScaleSpriteToFitSize(consoleIcon, iconSize);
	var iconPosition = new Vector2(global.GUIW * 0.5 - iconSize.w, 10);
	draw_sprite_ext(
		consoleIcon, 0,
		iconPosition.X, iconPosition.Y,
		iconScale, iconScale,
		0, c_white, 1
	);

	draw_set_font(font_small_bold);
	draw_set_color(consoleTextColor);
	draw_set_halign(fa_left);
	draw_set_valign(fa_middle);

	var consoleLogCountText = string("e:{0} w:{1} i:{2}", consoleLogErrorCount, consoleLogWarningCount, consoleLogInfoCount);
	draw_text(
		iconPosition.X + iconSize.w + 10,
		iconPosition.Y + (iconSize.h * 0.5),
		consoleLogCountText
	);
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}

if (global.GameSaveHandlerRef.show_auto_save_icon)
{
	var autoSaveIcon = sprFloppyDiskSave;
	var autoSaveIconSize = new Size(80, 80);
	var autoSaveIconPos = new Vector2(
		global.GUIW - autoSaveIconSize.w - 50,
		global.GUIH - autoSaveIconSize.h - 400
	);
	var autoSaveIconScale = ScaleSpriteToFitSize(autoSaveIcon, autoSaveIconSize);
	draw_sprite_ext(
		autoSaveIcon, 0,
		autoSaveIconPos.X, autoSaveIconPos.Y,
		autoSaveIconScale, autoSaveIconScale,
		0, c_white, 0.85
	);	
}