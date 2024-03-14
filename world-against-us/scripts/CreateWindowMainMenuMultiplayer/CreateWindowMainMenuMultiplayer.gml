function CreateWindowMainMenuMultiplayer(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var multiplayerWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var multiplayerElements = ds_list_create();
	var panelSize = new Size(600, 300);
	var multiplayerPanel = new WindowPanel(
		"MultiplayerPanel",
		new Vector2(windowSize.w * 0.5 - (panelSize.w * 0.5), windowSize.h * 0.5 - (panelSize.h * 0.5)),
		panelSize, #555973
	);
	ds_list_add(multiplayerElements, multiplayerPanel);
	
	var multiplayerPanelElements = ds_list_create();
	// PANEL TITLE
	var multiplayerPanelTitle = new WindowText(
		"MultiplayerPanelTitle",
		new Vector2(panelSize.w * 0.5, 20),
		undefined, undefined,
		"Multiplayer", font_default, fa_center, fa_middle, c_black, 1
	);
	
	var inputFieldColor = #538acf;
	
	// PLAYER TAG INPUT
	var inputSize = new Size(500, 30);
	var playerTagInputTitlePos = new Vector2(48, 50);
	var playerTagInputTitle = new WindowText(
		"MultiplayerPlayerTagInputTitle",
		playerTagInputTitlePos, undefined,
		undefined, "Username / Player Tag",
		font_small_bold, fa_left, fa_middle,
		c_black, 1
	);
	var playerTagInputPos = new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), 60);
	var playerTagInput = new WindowInput(
		"MultiplayerPlayerTagInput",
		playerTagInputPos, inputSize,
		inputFieldColor,
		string("*Name length {0}-{1} characters", MIN_PLAYER_TAG_LENGTH, MAX_PLAYER_TAG_LENGTH),
		MAX_PLAYER_TAG_LENGTH
	);
	
	// ADDRESS INPUT
	var addressInputTitlePos = new Vector2(48, 110);
	var addressInputTitle = new WindowText(
		"MultiplayerAddressInputTitle",
		addressInputTitlePos, undefined,
		undefined, "Server Address",
		font_small_bold, fa_left, fa_middle,
		c_black, 1
	);
	var addressInputPos = new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), 120);
	var addressInput = new WindowInput(
		"MultiplayerAddressInput",
		addressInputPos, inputSize,
		inputFieldColor, "*Address",
		MAX_ADDRESS_LENGTH
	);
	
	// PORT INPUT
	var portInputTitlePos = new Vector2(48, 170);
	var poertInputTitle = new WindowText(
		"MultiplayerPortInputTitle",
		portInputTitlePos, undefined,
		undefined, "Server Port",
		font_small_bold, fa_left, fa_middle,
		c_black, 1
	);
	var portInputPos = new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), 180);
	var portInput = new WindowInput(
		"MultiplayerPortInput",
		portInputPos, inputSize,
		inputFieldColor, "*Port",
		MAX_PORT_NUMBER_LENGTH
	);
	
	// SET DEFAULT SERVER PORT
	portInput.input = DEFAULT_HOST_PORT;
	
	// CONNECT BUTTON
	var buttonSize = new Size(120, 40);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#538acf, #245ca3,
		fa_left, fa_top,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	var multiplayerConnectButton = new WindowButton(
		"MultiplayerConnectButton",
		new Vector2(panelSize.w * 0.5 - (buttonSize.w * 0.5), panelSize.h - buttonSize.h - 30),
		buttonSize, buttonStyle.button_background_color, "Connect", buttonStyle, OnClickMenuConnect
	);
	
	ds_list_add(multiplayerPanelElements,
		multiplayerPanelTitle,
		playerTagInputTitle,
		playerTagInput,
		addressInputTitle,
		addressInput,
		poertInputTitle,
		portInput,
		multiplayerConnectButton
	);
	
	multiplayerWindow.AddChildElements(multiplayerElements);
	multiplayerPanel.AddChildElements(multiplayerPanelElements);
	return multiplayerWindow;
}