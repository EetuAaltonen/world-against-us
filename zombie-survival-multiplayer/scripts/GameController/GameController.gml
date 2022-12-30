function GameController(_objectIndex, _restrictedRooms, _deactiveRooms, _layerName = "Controllers") constructor
{
	objectIndex = _objectIndex;
	instance = noone;
	layerName = _layerName;
	
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