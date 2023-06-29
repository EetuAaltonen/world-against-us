function EnemyHorde(_hordeId, _instance, _enemyObject, _enemyCount, _enemyOffset) constructor
{
	hordeId = _hordeId;
	instance = _instance;
	enemyObject = _enemyObject;
	enemyCount = _enemyCount;
	enemyOffset = _enemyOffset;
	enemyLayer = "Characters";
	
	gridSpots = [];
	enemyPositions = [];
	ringCount = 1;
	innerRingSpotCount = 8;
	radius = 0;
	enemyInstances = ds_list_create();
	
	onCreate = true;
	
	static Update = function()
	{
		if (onCreate)
		{
			onCreate = false;
			UpdateHordeSize();
			SpawnEnemies();
			InitHordeGrid();
		}
	}
	
	static InitHordeGrid = function()
	{
		gridSpots = [];
		for (var i = 1; i <= ringCount; i++)
		{
			var currentRingSpotCount = (innerRingSpotCount * i);
			var spotVector = new Vector2(enemyOffset * i, 0);
			var angleStep = 360 / currentRingSpotCount;
			
			for (var j = 0; j < currentRingSpotCount; j++)
			{
				var newGridSpot = RotateVector2(spotVector, angleStep * j);
				array_push(gridSpots, newGridSpot);
			}
		}
		/*for (var i = 0; i < enemyCount; i++)
		{
			var newGridSpot = RotateVector2(spotVector, angle * i);
			array_push(gridSpots, newGridSpot);
		}*/
		array_copy(enemyPositions, 0, gridSpots, 0, array_length(gridSpots));
		UpdateHordeGrid(true);
	}
	
	static UpdateHordeSize = function()
	{
		var spotCount = innerRingSpotCount;
		while (true)
		{
			if (spotCount >= enemyCount) break;
			
			ringCount++;
			spotCount += (innerRingSpotCount * ringCount);
		}
		radius = (ringCount * enemyOffset) + (enemyOffset * 0.5);
	}
	
	static UpdateHordeGrid = function(_skipWander = false)
	{
		var gridSpotCount = array_length(gridSpots);
		for (var i = 0; i < gridSpotCount; i++)
		{
			var wanderChance = random_range(0, 1);
			var wanderThreshold = _skipWander ? 1 : 0.33;
			if (wanderChance <= wanderThreshold)
			{
				var gridSpot = gridSpots[@ i];
				var maxWanderOffset = enemyOffset * 0.5;
				var randomWanderOffset = new Vector2(
					irandom_range(-maxWanderOffset, maxWanderOffset),
					irandom_range(-maxWanderOffset, maxWanderOffset)
				);
				var newEnemyPosition = new Vector2(
					gridSpot.X + randomWanderOffset.X,
					gridSpot.Y + randomWanderOffset.Y
				);
				enemyPositions[@ i] = newEnemyPosition;
			
				var enemyInstance = enemyInstances[| i];
				if (instance_exists(enemyInstance))
				{
					enemyInstance.targetPosition = new Vector2(newEnemyPosition.X + instance.x, newEnemyPosition.Y + instance.y);
				}
			}
		}
	}
	
	static SpawnEnemies = function()
	{
		for (var i = 0; i < enemyCount; i++)
		{
			var enemyInstance = instance_create_depth(instance.x, instance.y, instance.depth, enemyObject);
			ds_list_add(enemyInstances, enemyInstance);
		}
	}
	
	static DrawDebug = function()
	{
		draw_circle_color(instance.x, instance.y, radius, c_red, c_red, true);
		draw_set_halign(fa_center);
		draw_text(instance.x, instance.y - radius - (enemyOffset * 2), hordeId);
		draw_set_halign(fa_left);
		
		var enemyPositionCount = array_length(enemyPositions);
		for (var i = 0; i < enemyPositionCount; i++)
		{
			var enemyPosition = enemyPositions[@ i];
			var relativeEnemyPosition = new Vector2(instance.x + enemyPosition.X, instance.y + enemyPosition.Y);
			draw_set_color(c_red);
			draw_text(relativeEnemyPosition.X - 10, relativeEnemyPosition.Y - 75, string(i));
			draw_set_color(c_black);
			draw_circle_color(instance.x + gridSpots[@ i].X, instance.y + gridSpots[@ i].Y, (enemyOffset * 0.5), c_blue, c_blue, true);
		}
	}
}