function DeleteStruct(_struct)
{
	if (is_struct(_struct))
	{
		if (struct_exists(_struct, "OnDestroy"))
		{
			_struct.OnDestroy(_struct);
		}
		delete _struct;
	}
}