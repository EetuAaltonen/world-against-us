/// @description Custom RoomStartEvent
// FETCH CHARACTER FROM GLOBAL VARIABLE
if (is_undefined(character))
{
	character = global.PlayerCharacter;
}

// NETWORKING
if (global.MultiplayerMode)
{
	if (character.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
	{
		positionSyncTImer.StartTimer();
	}
}
