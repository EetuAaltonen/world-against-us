function FormatSaveName(saveName)
{
	var formatSaveName = string_lettersdigits(string_replace_all(string_lower(saveName), " ", "_"));
	return formatSaveName;
}