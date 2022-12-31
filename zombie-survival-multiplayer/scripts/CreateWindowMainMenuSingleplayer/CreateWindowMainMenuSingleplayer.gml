function CreateWindowMainMenuSingleplayer(_zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var singleplayerWindow = new GameWindow(
		GAME_WINDOW.MainMenuSingleplayer,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var saveFileElements = ds_list_create();
	var saveFiles = global.GameSaveHandlerRef.FetchSaveFileNames();
	var saveFileListSize = new Size(300, windowSize.h - 20);
	var saveFileList = new WindowList(
		"SaveFileList",
		new Vector2(10, 10),
		saveFileListSize,
		c_dkgray, saveFiles, ListDrawSaveFile, true, OnClickListSaveFile
	);
	
	var panelSize = new Size(600, 200);
	var saveFilePanel = new WindowPanel(
		"SaveFilePanel",
		new Vector2(windowSize.w * 0.5 - (panelSize.w * 0.5), windowSize.h * 0.5 - (panelSize.h * 0.5)),
		panelSize, #555973
	);
	ds_list_add(saveFileElements,
		saveFilePanel,
		saveFileList
	);
	
	var saveFilePanelElements = ds_list_create();
	// PANEL TITLE
	var saveFilePanelTitle = new WindowText(
		"saveFilePanelTitle",
		new Vector2(panelSize.w * 0.5, 20),
		undefined, undefined,
		"Save file", font_default, fa_center, fa_middle, c_black, 1
	);
	
	// SAVE NAME
	var inputSize = new Size(500, 30);
	var saveInput = new WindowInput(
		"SaveInput",
		new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), panelSize.h * 0.5 - (inputSize.h * 0.5) - 20),
		inputSize, #48a630, "*Save name"
	);
	
	// PLAY BUTTON
	var buttonSize = new Size(100, 30);
	var buttonStyle = new ButtonStyle(
		buttonSize, #48a630, #2c8017, font_default, 0, undefined, undefined
	);
	var savePlayButton = new WindowButton(
		"SavePlayButton",
		new Vector2(panelSize.w * 0.5 - (buttonSize.w * 0.5), panelSize.h - buttonSize.h - 20),
		buttonSize, buttonStyle.color, "Play", buttonStyle, OnClickMenuSingleplayerPlay
	);
	
	ds_list_add(saveFilePanelElements,
		saveFilePanelTitle,
		saveInput,
		savePlayButton
	);
	
	singleplayerWindow.AddChildElements(saveFileElements);
	saveFilePanel.AddChildElements(saveFilePanelElements);
	return singleplayerWindow;
}