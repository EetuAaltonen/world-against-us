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
				DeleteStruct(_variable);
			}
		}
	}
}