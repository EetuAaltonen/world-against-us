function OnClickMenuSingleplayerPlay()
{
	var saveInput = parentElement.GetChildElementById("SaveInput");
	if (saveInput.input != saveInput.placeholder)
	{
		if (string_length(saveInput.input) > 3)
		{
			global.GameSaveHandlerRef.SetSaveFileName(saveInput.input);
			room_goto(roomMap1);
		} else {
			ds_list_add(global.MessageLog, "Save file name is too short (min 4)");
		}
	} else {
		ds_list_add(global.MessageLog, "Save file name can't be empty");
	}
}