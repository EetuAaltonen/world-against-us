function CreateWindowMainMenuSaveSelection(_gameWindowId, _zIndex, playCallbackFunction)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var saveSelectionWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	// SAVE FILE LIST
	var saveFileElements = ds_list_create();show_debug_message("CreateWindowMainMenuSaveSelection " + string(saveFileElements));
	
	var saveFileNames = ds_list_create();
	global.GameSaveHandlerRef.FetchSaveFileNames(saveFileNames);
	var saveFileListSize = new Size(300, windowSize.h - 80);
	var saveFileListPosition = new Vector2(10, 60);
	var saveFileList = new WindowCollectionList(
		"SaveFileList",
		saveFileListPosition,
		saveFileListSize,
		#555973, saveFileNames,
		ListDrawSaveFile, true, OnClickListSaveFile
	);
	
	// SAVE FILE LIST TITLE
	var saveFileListTitlePosition = new Vector2(10 + (saveFileListSize.w * 0.5), 10);
	var saveFileListTitle = new WindowText(
		"SaveFileListTitle",
		saveFileListTitlePosition,
		undefined, undefined,
		"--Save files--", font_large, fa_center, fa_top, c_white, 1
	);
	
	// SAVE FILE LOAD PANEL
	var panelSize = new Size(800, 300);
	var saveFilePanel = new WindowPanel(
		"SaveFilePanel",
		new Vector2(windowSize.w * 0.5 - (panelSize.w * 0.5), windowSize.h * 0.5 - (panelSize.h * 0.5)),
		panelSize, #555973
	);
	ds_list_add(saveFileElements,
		saveFileListTitle,
		saveFileList,
		saveFilePanel
	);
	
	var saveFilePanelElements = ds_list_create();
	// PANEL TITLE
	var saveFilePanelTitle = new WindowText(
		"SaveFilePanelTitle",
		new Vector2(panelSize.w * 0.5, 50),
		undefined, undefined,
		"Save file", font_large, fa_center, fa_middle, c_black, 1
	);
	
	// SAVE NAME
	var inputSize = new Size(700, 50);
	var saveInput = new WindowInput(
		"SaveInput",
		new Vector2(panelSize.w * 0.5 - (inputSize.w * 0.5), panelSize.h * 0.5 - (inputSize.h * 0.5) - 20),
		inputSize, #48a630, "*Save name",
		MAX_SAVE_NAME_LENGTH
	);
	
	// PLAY BUTTON
	var buttonSize = new Size(160, 60);
	var buttonPosition = new Vector2(
		panelSize.w * 0.5 - buttonSize.w - 5,
		panelSize.h - (buttonSize.h * 0.5) - 60
	);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#48a630, #2c8017,
		fa_left, fa_middle,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	var savePlayButton = new WindowButton(
		"SavePlayButton",
		buttonPosition, buttonSize,
		buttonStyle.button_background_color, "Play", buttonStyle, playCallbackFunction
	);
	
	// DELETE BUTTON
	buttonPosition = new Vector2(
		panelSize.w * 0.5 + 5,
		panelSize.h - (buttonSize.h * 0.5) - 60
	);
	buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#a63030, #801717,
		fa_left, fa_middle,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	var deletePlayButton = new WindowButton(
		"DeletePlayButton",
		buttonPosition,	buttonSize,
		buttonStyle.button_background_color, "Delete", buttonStyle, OnClickMenuSaveSelectionDelete
	);
	
	ds_list_add(saveFilePanelElements,
		saveFilePanelTitle,
		saveInput,
		savePlayButton,
		deletePlayButton
	);
	
	// OVERRIDE WINDOW ONCLOSE FUNCTION
	var overrideOnClose = function()
	{
		// DISCONNECT FROM A HOST IF SAVE SELECTION INTERRUPTED
		if (global.NetworkHandlerRef.network_status == NETWORK_STATUS.CONNECTED)
		{
			global.NetworkHandlerRef.RequestDisconnectSocket(true);
		}
	}
	saveSelectionWindow.OnClose = overrideOnClose;
	
	saveSelectionWindow.AddChildElements(saveFileElements);
	saveFilePanel.AddChildElements(saveFilePanelElements);
	return saveSelectionWindow;
}