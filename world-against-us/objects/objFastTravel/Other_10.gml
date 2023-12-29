/// @description Custom RoomStartEvent
var currentRoom = room_get_name(room);
if (currentRoom == ROOM_INDEX_CAMP)
{
	fastTravelHandler.ClearAllCacheFastTravelInfo();
} else {
	fastTravelHandler.DeleteCacheFastTravelInfo(currentRoom);
}