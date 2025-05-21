// INHERIT THE PARENT EVENT
event_inherited();

// DON'T DESTROY CHARACTER POINTING TO GLOBAL VARIABLE
if (character.behavior != CHARACTER_BEHAVIOR.PLAYER)
{
	character.OnDestroy();
	character = undefined;
}