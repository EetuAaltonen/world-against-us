function ConcatSaveFileSuffix(saveName)
{
	var saveFileName = string("{0}{1}", saveName, SAVE_FILE_SUFFIX);
	return saveFileName;
}