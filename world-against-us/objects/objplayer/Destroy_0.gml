// OVERRIDE INHERITED EVENT
if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
{
	// DON'T DESTROY CHARACTER POINTING TO GLOBAL VARIABLE
	return;
}

character.OnDestroy();
character = undefined;