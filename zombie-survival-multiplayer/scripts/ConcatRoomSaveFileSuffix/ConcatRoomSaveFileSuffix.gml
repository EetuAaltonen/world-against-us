function ConcatRoomSaveFileSuffix(saveName, roomName)
{
	var saveFileName = string("{0}{1}", saveName, string(SAVE_FILE_SUFFIX_ROOM, roomName));
	return saveFileName;
}