// INHERITED EVENT
event_inherited();

// CHECK GUI STATE
if (!global.GUIStateHandler.IsGUIStateClosed()) return;

if (instance_exists(global.ObjPlayer))
{
	insideInteractionRange = (point_distance(x, y, global.ObjPlayer.x, global.ObjPlayer.y) < interactionRange);
	
	if (insideInteractionRange && keyboard_check_released(ord("F")))
	{
		// OPEN	ESC MENU
		var guiState = new GUIState(
			GUI_STATE.Facility, undefined, undefined,
			[GAME_WINDOW.PlayerBackpack, GAME_WINDOW.Facility], GUI_CHAIN_RULE.OverwriteAll
		);
		if (global.GUIStateHandler.RequestGUIState(guiState))
		{
			global.GameWindowHandler.OpenWindowGroup([
				CreateWindowPlayerBackpack(-1),
				CreateWindowFacilityGenerator(-1, facility)
			]);
		}
	}
}