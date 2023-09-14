function CreateWindowDialogue(_gameWindowId, _zIndex, _characterIcon)
{
	var windowSize = new Size(global.GUIW, global.ObjHud.hudHeight + 300);
	var windowPosition = new Vector2(0, global.GUIH - windowSize.h - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.8);
	var dialogueWindow = new GameWindow(
		_gameWindowId,
		windowPosition,
		windowSize, windowStyle, _zIndex
	);
	
	var dialogueElements = ds_list_create();
	
	var characterIconSize = new Size(windowSize.h - 10,  windowSize.h - 10);
	var dialogueCharacterIcon = new WindowAnimation(
		"characterIcon",
		new Vector2(10, 10),
		characterIconSize,
		undefined, _characterIcon, 0, 1, 0, 0.25
	);
	
	var dialogueChatPosition = new Vector2(420, 20);
	var dialogueChatSize = new Size(windowSize.w - 420, 80);
	var dialogueChat = new WindowText(
		"chat",
		dialogueChatPosition,
		dialogueChatSize,
		undefined, "Chat text", font_default, fa_left, fa_top, c_white, 1
	);
	
	var dialogueOptionsPosition = new Vector2(420, 120);
	var dialogueOptionsSize = new Size(
		windowSize.w - dialogueOptionsPosition.X,
		windowSize.h - dialogueOptionsPosition.Y
	);
	var optionButtonStyle = new ButtonStyle(
		new Size(dialogueOptionsSize.w, 30), 2,
		undefined, undefined,
		fa_left, fa_top,
		c_white, c_yellow,
		font_default,
		fa_left, fa_middle
	);
	var dialogueOptions = new WindowButtonMenu(
		"options",
		dialogueOptionsPosition,
		dialogueOptionsSize,
		undefined, undefined,
		optionButtonStyle
	);
	
	ds_list_add(dialogueElements,
		dialogueCharacterIcon,
		dialogueChat,
		dialogueOptions
	);
	
	dialogueWindow.AddChildElements(dialogueElements);
	return dialogueWindow;
}