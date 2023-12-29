function OnClickMenuMultiplayer()
{
	global.GUIStateHandlerRef.RequestGUIView(GUI_VIEW.Multiplayer, [
		CreateWindowMainMenuMultiplayer(GAME_WINDOW.MainMenuMultiplayer, parentWindow.zIndex - 1)
	], GUI_CHAIN_RULE.Append);
}