// OVERRIDE INHERITED EVENT
if (character.behavior == CHARACTER_BEHAVIOR.PLAYER)
{
	// DON'T DESTROY CHARACTER POINTING TO GLOBAL VARIABLE
	return;
}

character.OnDestroy();
character = undefined;