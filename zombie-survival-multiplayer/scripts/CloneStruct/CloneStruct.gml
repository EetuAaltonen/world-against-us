// ITERATES ON THE INNER STURCTS CASES
function CloneStruct(struct)
{
    var key, value;
    var cloneStruct = {};
	if (!is_undefined(struct))
	{
	    var keys = variable_struct_get_names(struct);
	    for (var i = array_length(keys)-1; i >= 0; --i) {
	            key = keys[i];
	            value = struct[$ key];
	            variable_struct_set(cloneStruct, key, !is_struct(value) ? value : CloneStruct(value));
	    }
	}
    return cloneStruct;
}