function LootTable(_tag, _pools) constructor
{
	tag = _tag;
	pools = _pools;
	
	static RollLoot = function()
	{ 
		var loot = [];
		var poolCount = array_length(pools);
		for (var i = 0; i < poolCount; i++)
		{
			var pool = pools[@ i];
			var isPoolRolled = (irandom_range(1, 100) <= pool.roll_chance);
			if (isPoolRolled)
			{
				// POOL WITH 0 AS MIN AND MAX ROLLS WILL ADD ALL THE ITEMS AS LOOT
				if (pool.rolls.min_roll == 0 && pool.rolls.max_roll == 0) {
					var entryCount = array_length(pool.entries);
					for (var j = 0; j < entryCount; j++)
					{
						array_push(loot, pool.entries[@ j]);
					}
				// OTHERWISE ROLL RANDOM COUNT OF ITEMS BETWEEN MIN AND MAX
				} else {
					var rollCount = irandom_range(pool.rolls.min_roll, pool.rolls.max_roll);
					for (var j = 0; j < rollCount; j++)
					{
						array_push(loot, pool.RollEntry());
					}
				}
			}
		}
		return array_shuffle(loot);
	}
}