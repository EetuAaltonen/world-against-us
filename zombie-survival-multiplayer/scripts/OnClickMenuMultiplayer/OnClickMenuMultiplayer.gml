function OnClickMenuMultiplayer()
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	
	var multiplayerWindow = new GameWindow(
		"MultiplayerWindow",
		new Vector2(0, 0),
		windowSize, windowStyle, parentWindow.zIndex - 1
	);
	
	var multiplayerElements = ds_list_create();
	var panelSize = new Size(600, 200);
	var multiplayerPanel = new WindowPanel(
		"MultiplayerPanel",
		new Vector2(windowSize.w * 0.5 - (panelSize.w * 0.5), windowSize.h * 0.5 - (panelSize.h * 0.5)),
		panelSize, #555973
	);
	ds_list_add(multiplayerElements, multiplayerPanel);
	
	var multiplayerPanelElements = ds_list_create();
	// PANEL TITLE
	ds_list_add(multiplayerPanelElements,
		new WindowText(
			"MultiplayerPanelTitle",
			new Vector2(panelSize.w * 0.5, 20),
			undefined, undefined,
			"Multiplayer", font_default, fa_center, fa_middle, c_black, 1
		)
	);
	
	// ADDRESS & PORT INPUT
	var inputSize = new Size(500, 30);
	var addressInput = new WindowInput(
		"MultiplayerAddressInput",
		new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), panelSize.h * 0.5 - (inputSize.h * 0.5) - 20),
		inputSize, #48a630, "*Address"
	);
	var portInput = new WindowInput(
		"MultiplayerPortInput",
		new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), panelSize.h * 0.5 - (inputSize.h * 0.5) + 20),
		inputSize, #48a630, "*Port"
	);
	
	ds_list_add(multiplayerPanelElements,
		addressInput,
		portInput
	);
	
	// CONNECT BUTTON
	var buttonSize = new Size(100, 30);
	var formInputElements = ds_list_create();
	ds_list_add(formInputElements,
		addressInput,
		portInput
	);
	
	ds_list_add(multiplayerPanelElements,
		new WindowFormButton(
			"MultiplayerConnectButton",
			new Vector2(panelSize.w * 0.5 - (buttonSize.w * 0.5), panelSize.h - buttonSize.h - 20),
			buttonSize, #48a630, "Connect", OnClickMenuConnect, formInputElements
		)
	);
	
	// ADD NEW WINDOW
	multiplayerWindow.AddChildElements(multiplayerElements);
	multiplayerPanel.AddChildElements(multiplayerPanelElements);
	ds_list_add(global.ObjWindowHandler.gameWindows, multiplayerWindow);
}