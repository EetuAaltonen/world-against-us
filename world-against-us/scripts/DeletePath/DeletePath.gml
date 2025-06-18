function DeletePath(_path)
{
	if (path_exists(_path ?? -1))
	{
		path_delete(_path);
	}
}