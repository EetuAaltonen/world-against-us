function ReleaseVariableFromMemory(_variable, _variableType = undefined, _contentVariableType = undefined)
{
	if (!is_undefined(_variable))
	{
		switch(_variableType)
		{
			case ds_type_list:
			{
				DestroyDSListAndDeleteValues(_variable, _contentVariableType);
			} break;
			case ds_type_map:
			{
				DestroyDSMapAndDeleteValues(_variable, _contentVariableType);
			} break;
			case ds_type_priority:
			{
				DestroyDSPriorityAndDeleteValues(_variable, _contentVariableType);
			} break;
			default:
			{
				if (is_struct(_variable))
				{
					StructOnDestroy(_variable);
					delete _variable;
				} else if (is_array(_variable))
				{
					ClearArrayAndDeleteValues(_variable, _contentVariableType);
				} else if (is_string(_variable))
				{
					// IGNORE STRING TYPE VALUES
				} else if (is_numeric(_variable))
				{
					// IGNORE NUMERIC TYPE VALUES
				} else {
					throw(string("Trying to delete variable with incorrect type with value {0}", _variable));
				}
			}
		}
	}
}