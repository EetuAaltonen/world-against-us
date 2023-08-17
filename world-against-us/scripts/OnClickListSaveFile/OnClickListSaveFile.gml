function OnClickListSaveFile()
{
	var saveFilePanel = parentWindow.GetChildElementById("SaveFilePanel");
	var saveInput = saveFilePanel.GetChildElementById("SaveInput");
	saveInput.input = string_replace(elementData, SAVE_FILE_SUFFIX_PLAYER_DATA, "");
	saveInput.isTyping = false;
}