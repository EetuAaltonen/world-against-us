// INHERIT THE PARENT EVENT
event_inherited();

// DESTROY CHARACTER WHEN NEEDED 
// DON'T DESTROY CHARACTER POINTING TO GLOBAL VARIABLE
// TO PREVENT PLAYER DATA LOSS
if (!is_undefined(character))
{
	if (character.behavior != CHARACTER_BEHAVIOR.PLAYER)
	{
		ReleaseVariableFromMemory(character);
		character = undefined;
	}
}

ReleaseVariableFromMemory(aiBase);
aiBase = undefined;

ReleaseVariableFromMemory(aiStates, ds_type_map);
aiStates = undefined;