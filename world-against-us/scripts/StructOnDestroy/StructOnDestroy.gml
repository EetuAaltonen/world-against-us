function StructOnDestroy(_variable)
{
	var struct = static_get(_variable);
	// UNDEFINED VALUE INDICATES THAT STRUCT IS THE BUILT-IN ROOT OF ALL OTHER STRUCTS
	while (!is_undefined(static_get(struct)))
	{
		if (struct_exists(struct, "OnDestroy"))
		{
			struct.OnDestroy(_variable);
		} else {
			show_debug_message(struct);
			show_debug_message(_variable);
			throw(string("{0} is missing OnDestroy method on struct-chain of {1}", static_get(struct), static_get(_variable)));
		}
		struct = static_get(struct);
	};
}