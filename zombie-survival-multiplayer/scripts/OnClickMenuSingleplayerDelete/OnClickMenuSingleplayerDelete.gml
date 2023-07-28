function OnClickMenuSingleplayerDelete()
{
	var saveInput = parentElement.GetChildElementById("SaveInput");
	if (saveInput.input != saveInput.placeholder)
	{
		var saveName = FormatSaveName(saveInput.input);
		var saveFileName = ConcatSaveFileSuffix(saveName);
		
		CreateAndOpenWindowConfirm(
			"Delete Save",
			string("Are you sure you want to delete '{0}'?", saveFileName),
			self, OnClickMenuSingleplayerDeleteConfirmCallback
		);
	} else {
		ds_list_add(global.MessageLog, "No save file selected");
	}
}