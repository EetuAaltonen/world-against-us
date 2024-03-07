function AIEnemyHuman(_instanceRef, _aiStates, _defaultAIStateIndex, _character, _targetSeekInterval, _pathUpdateInterval, _pathBlockingRadius) : AIBase(_instanceRef, _aiStates, _defaultAIStateIndex) constructor
{
	// CHARACTER
	character = _character;
	
	// TARGET
	target_seek_interval = _targetSeekInterval; //ms
	target_seek_timer = new Timer(target_seek_interval);
	target_instance = noone;
	target_position = undefined;
	
	// PATHING
	path_to_target = new Path();
	path_update_interval = _pathUpdateInterval; //ms
	path_update_timer = new Timer(path_update_interval);
	path_update_threshold = MetersToPixels(4);
	path_blocking_radius = _pathBlockingRadius;
	
	static OnDestroy = function(_struct = self)
	{
		// INHERIT PARENT METHOD
		static_get(static_get(AIEnemyHuman)).OnDestroy(_struct);
		
		DeletePath(_struct.path_to_target);
		DeleteStruct(_struct.target_seek_timer);
		DeleteStruct(_struct.path_update_timer);
	}
	
	static SetTargetInstance = function(_targetInstance)
	{
		// SET TARGET INSTANCE
		target_instance = _targetInstance ?? _targetInstance;
		
		// SET TARGET POSITION
		SetTargetPosition(instance_exists(target_instance) ? GetInstanceOriginPosition(target_instance) : undefined);
	}
	
	static SetTargetPosition = function(_targetPosition)
	{
		target_position = _targetPosition;
	}
	
	static StartPathingToTarget = function(_potential = false)
	{
		var isPathingStarted = false;
		if (instance_exists(target_instance))
		{
			var instanceOriginPosition = GetInstanceOriginPosition(instance_ref);
			if (!is_undefined(instanceOriginPosition))
			{
				if (!is_undefined(target_position))
				{
					var isPathFound = false;
					var pathingSpeed = (!is_undefined(instance_ref.character)) ? instance_ref.character.max_speed : 0;
					
					// CALCULATE PATH TO TARGET
					if (_potential)
					{
						var yOffset = instance_ref.y - instance_ref.bbox_bottom;
						isPathFound = path_to_target.CalculatePotentialPath(
							target_position.X, target_position.Y + yOffset,
							instance_ref, pathingSpeed
						);
					} else {
						isPathFound = path_to_target.CalculatePath(
							instanceOriginPosition.X, instanceOriginPosition.Y,
							target_position.X, target_position.Y,
							true
						);
					}
					
					// START PATH
					if (isPathFound)
					{
						isPathingStarted = StartPathing(path_to_target.path, pathingSpeed, path_action_stop, false);
					} else {
						var consoleLog = string("Failed to find AI pathing from {0} position to target {1}", object_get_name(instance_ref.object_index), object_get_name(target_instance.object_index))
						global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
					}
				}
			}
		}
		return isPathingStarted;
	}
	
	static StartPathingToPoint = function()
	{
		var isPathingStarted = false;
		var instanceOriginPosition = GetInstanceOriginPosition(instance_ref);
		if (!is_undefined(instanceOriginPosition))
		{
			if (path_to_target.CalculatePath(
				instanceOriginPosition.X, instanceOriginPosition.Y,
				target_position.X, target_position.Y,
				true
			))
			{
				// START PATH
				var pathingSpeed = (!is_undefined(instance_ref.character)) ? instance_ref.character.max_speed : 0;
				isPathingStarted = StartPathing(path_to_target.path, pathingSpeed, path_action_stop, false);
				
			}
		}
		return isPathingStarted;
	}
	
	static StartPathing = function(_path, _speed, _pathEndAction, _absolute, _pathPosition = 0)
	{
		var isPathingStarted = false;
		if (path_exists(_path))
		{
			with (instance_ref)
			{
				path_start(_path, _speed, _pathEndAction, _absolute);
				path_position = _pathPosition;
			}
			isPathingStarted = true;
		}
		return isPathingStarted;
	}
	
	static EndPathing = function()
	{
		with (instance_ref)
		{
			path_end();	
		}
	}
	
	static CheckPathBlocking = function()
	{
		// TODO: Verify that this logic works
		/*var pathPointStep = 1 / path_get_number(pathToTarget);
		var pathPointNext = new Vector2(
			path_get_x(pathToTarget, path_position + pathPointStep),
			path_get_y(pathToTarget, path_position + pathPointStep)
		);
		var nearestBlockingInstance = FindNearestInstanceToPoint(pathPointNext, objBandit, id);
		if (nearestBlockingInstance != noone)
		{
			var distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
					
			if (point_distance(pathPointNext.X, pathPointNext.Y, nearestBlockingInstance.x, nearestBlockingInstance.y) <= pathBlockingRadius &&
								distanceToTarget >= distanceBlockingToTarget)
			{
				path_end();
			} else {
				nearestBlockingInstance = FindNearestInstanceToPoint(new Vector2(x, y), objBandit, id);
				distanceBlockingToTarget = point_distance(nearestBlockingInstance.x, nearestBlockingInstance.y, targetInstance.x, targetInstance.y);
				if (distance_to_object(nearestBlockingInstance) <= pathBlockingRadius &&
					distanceToTarget >= distanceBlockingToTarget)
				{
					path_end();
				}	
			}
		}*/
	}
	
	static IsTargetInVisionRadius = function(_targetInstance)
	{
		var isInVisionRadius = false;
		var distanceToTarget = GetDistanceBetweenInstances(instance_ref, target_instance);
		if (!is_undefined(distanceToTarget))
		{
			var visionRadius = (!is_undefined(instance_ref.character)) ? instance_ref.character.vision_radius : 0;
			isInVisionRadius = (distanceToTarget <= visionRadius);
		}
		return isInVisionRadius;
	}
	
	static IsTargetInCloseRange = function(_targetInstance)
	{
		var isInCloseRange = false;
		var distanceToTarget = GetDistanceBetweenInstances(instance_ref, target_instance);
		if (!is_undefined(distanceToTarget))
		{
			var closeRangeRadius = (!is_undefined(instance_ref.character)) ? instance_ref.character.close_range_radius : 0;
			isInCloseRange = (distanceToTarget <= closeRangeRadius);
		}
		return isInCloseRange;
	}
	
	static GetNearestTargetInstanceInRadius = function(_objectIndex, _seekRadius)
	{
		var nearestTargetInstance = noone;
		var nearestDistance = infinity;
		var nearTargetInstances = GetNearTargetInstancesInRadius(_objectIndex, _seekRadius);
		var nearTargetCount = array_length(nearTargetInstances);
		for (var i = 0; i < nearTargetCount; i++)
		{
			var targetInstance = nearTargetInstances[@ i];
			if (instance_exists(targetInstance))
			{
				var isTargetInvulnerable = (!is_undefined(targetInstance.character)) ? targetInstance.character.IsInvulnerableState() : true;
				if (!isTargetInvulnerable)
				{
					var distanceToTarget = GetDistanceBetweenInstances(instance_ref, targetInstance);
					if (distanceToTarget < nearestDistance)
					{
						nearestTargetInstance = targetInstance;
						nearestDistance = distanceToTarget;
					}
				}
			}
		}
		return nearestTargetInstance;
	}
	
	static GetNearTargetInstancesInRadius = function(_objectIndex, _seekRadius)
	{
		var nearTargetInstances = [];
		with (_objectIndex)
		{
			if (id != other)
			{
				var distanceToSeeker = GetDistanceBetweenInstances(self, other.instance_ref)
				if (!is_undefined(distanceToSeeker))
				{
					if (distanceToSeeker <= _seekRadius)
					{
						array_push(nearTargetInstances, id);
					}
				}
			}
		}
		return nearTargetInstances;
	}
}