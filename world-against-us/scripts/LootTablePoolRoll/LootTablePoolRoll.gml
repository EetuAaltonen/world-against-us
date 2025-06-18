function LootTablePoolRoll(_min_roll, _max_roll) constructor
{
	min_roll = _min_roll;
	max_roll = _max_roll;
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
}