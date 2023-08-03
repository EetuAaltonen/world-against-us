// ITERATES ON THE INNER STURCTS CASES
function CloneStruct(struct)
{
    var cloneStruct = EMPTY_STRUCT;
	if (!is_undefined(struct))
	{
	    var keys = variable_struct_get_names(struct);
		var keyCount = array_length(keys);
	    for (var i = 0; i < keyCount; ++i) {
			var key = keys[i];
			var value = struct[$ key];
			variable_struct_set(cloneStruct, key, !is_struct(value) ? value : CloneStruct(value));
	    }
	}
    return cloneStruct;
}