function CollisionPoint(_nearest_instance, _position) constructor
{
	nearest_instance = _nearest_instance;
	position = _position;
	
	static Clone = function()
	{ 
		return new CollisionPoint(
			nearest_instance,
			position
		);
	}
}