function CharacterZombie(_name, _type, _race, _behavior, _colliderRef) : Character(_name, _type, _race, _behavior) constructor
{
	collider_ref = _colliderRef;
	
	// MOBILITY
	// TODO: Add variables for walking and running
	// and make this adjustable
	max_speed = 0.8;
	
	// SENSES
	vision_radius = MetersToPixels(6);
	
	// COMBAT
	close_range_radius = MetersToPixels(2);
	
	static ToJSONStruct = function()
	{
		var scaledStamina = ScaleFloatValueToInt(stamina);
		return {
			name: name,
			uuid: uuid,
			type: type,
			race: race,
			stamina: scaledStamina,
		}
	}
}