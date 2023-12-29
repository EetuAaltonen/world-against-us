function OnClickMenuSingleplayer()
{
	global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.Singleplayer, [
		CreateWindowMainMenuSaveSelection(GAME_WINDOW.MainMenuSingleplayer, parentWindow.zIndex - 1, OnClickMenuSingleplayerPlay)
	], GUI_CHAIN_RULE.Append);
}