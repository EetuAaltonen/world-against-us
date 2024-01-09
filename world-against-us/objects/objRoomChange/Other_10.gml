/// @description Custom RoomStartEvent
var currentRoom = room_get_name(room);
// CLEAR FAST TRAVEL INFO CACHE IN MAIN MENU AND CAMP
if (!IS_ROOM_IN_GAME_WORLD || currentRoom == ROOM_INDEX_CAMP)
{
	roomChangeHandler.ClearAllCacheFastTravelInfo();
} else {
	roomChangeHandler.DeleteCacheFastTravelInfo(currentRoom);
}