function GameController(_objectIndex, _restrictedRooms, _deactiveRooms) constructor
{
	objectIndex = _objectIndex;
	instance = noone;
	
	restrictedRooms = _restrictedRooms;
	deactiveRooms = _deactiveRooms;
	
	
	static SetInstance = function(_instance)
	{
		instance = _instance;
	}
	
	static RemoveInstance = function()
	{
		instance = noone;
	}
}