function ReleaseVariableFromMemory(_variable, _variableType = undefined)
{
	if (!is_undefined(_variable))
	{
		switch(_variableType)
		{
			case ds_type_list:
			{
				ClearDSListAndDeleteValues(_variable);
				ds_list_destroy(_variable);
			} break;
			case ds_type_map:
			{
				ClearDSMapAndDeleteValues(_variable);
				ds_map_destroy(_variable);
			} break;
			case ds_type_priority:
			{
				ClearDSPriorityAndDeleteValues(_variable);
				ds_priority_destroy(_variable);
			} break;
			default:
			{
				// TODO: Replace with DeleteStruct(...)
				if (is_struct(_variable))
				{
					if (struct_exists(_variable, "OnDestroy"))
					{
						_variable.OnDestroy();
					}
					delete _variable;
				}
			}
		}
	}
}