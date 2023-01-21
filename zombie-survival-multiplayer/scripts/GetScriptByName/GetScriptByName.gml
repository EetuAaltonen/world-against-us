function GetScriptByName(_scriptName)
{
	var scriptIndex = asset_get_index(_scriptName);
	if (!script_exists(scriptIndex)) { scriptIndex = undefined; }
	return scriptIndex;
}