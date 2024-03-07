function IsPathExist(_path)
{
	return (!is_undefined(_path)) ? path_exists(_path) : false;	
}