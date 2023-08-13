// INHERIT THE PARENT EVENT
event_inherited();

interactionText = "Fast travel to Town";
interactionFunction = function()
{
	room_goto(roomTown);
}