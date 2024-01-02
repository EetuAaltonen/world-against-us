/// @description Custom RoomStartEvent
// FETCH CHARACTER FROM GLOBAL VARIABLE
character = global.PlayerCharacter;

// NETWORKING
if (global.MultiplayerMode)
{
	positionSyncTImer.StartTimer();
}