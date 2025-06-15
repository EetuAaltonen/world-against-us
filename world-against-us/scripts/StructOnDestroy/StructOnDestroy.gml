function StructOnDestroy(_variable)
{
	var struct = static_get(_variable);
	// UNDEFINED INDICATES TO BUILT-IN ROOT STRUCT
	while (!is_undefined(struct))
	{
		if (struct_exists(struct, "OnDestroy"))
		{
			struct.OnDestroy(struct);
		}
		struct = static_get(struct);
	};
}