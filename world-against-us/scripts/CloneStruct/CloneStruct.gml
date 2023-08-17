// ITERATES ON THE INNER STURCTS CASES
function CloneStruct(struct)
{
    var cloneStruct = EMPTY_STRUCT;
	if (!is_undefined(struct))
	{
	    var variableNames = variable_struct_get_names(struct);
		var variableNameCount = array_length(variableNames);
	    for (var i = 0; i < variableNameCount; ++i) {
			var variableName = variableNames[i];
			var value = struct[$ variableName];
			variable_struct_set(cloneStruct, variableName, !is_struct(value) ? value : CloneStruct(value));
	    }
	}
    return cloneStruct;
}