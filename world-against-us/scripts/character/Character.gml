function Character(_name, _type, _race, _behavior) constructor
{
	name = _name;
	uuid = undefined;
	type = _type;
	race = _race;
	behavior = _behavior;
	stamina = 100;
	
	static Clone = function()
	{
		return new Character(
			name,
			type,
			race,
			behavior
		);
	}
	
	static OnDestroy = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static Update = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
	
	static OnDead = function()
	{
		// OVERRIDE THIS FUNCTION
		return;
	}
}