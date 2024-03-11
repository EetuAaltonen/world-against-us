function AIStateBanditPatrol(_aiBase)
{
	// UPDATE PATROL POSITION
	_aiBase.UpdatePatrolPosition();
	
	// UPDATE PATROL ROUTE PROGRESS
	_aiBase.UpdatePatrolRouteProgress();
	
	// CHECK PATROL ROUTE END
	if (_aiBase.patrol.route_progress < 1)
	{
		if (!global.MultiplayerMode || global.NetworkRegionHandlerRef.IsClientRegionOwner())
		{
			_aiBase.target_seek_timer.Update();
			if (_aiBase.target_seek_timer.IsTimerStopped())
			{
				// RESTART TARGET SEEK TIMER
				_aiBase.target_seek_timer.StartTimer();	
				
				// SEEK TARGET
				var targetInstanceInVision = _aiBase.SeekTargetInVision(objPlayer);
				if (instance_exists(targetInstanceInVision))
				{
					// SET TARGET INSTANCE
					_aiBase.SetTargetInstance(targetInstanceInVision);
					
					// START CHASE
					if (_aiBase.StartChasingTarget())
					{
						// NETWORKING
						if (global.MultiplayerMode)
						{
							// NETWORKING
							global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);	
						}
					} else {
						var consoleLog = string("Failed to {0} AI start chasing target", object_get_name(_aiBase.instance_ref.object_index));
						global.ConsoleHandlerRef.AddConsoleLog(CONSOLE_LOG_TYPE.WARNING, consoleLog);
					}
				}
			}
		}
	} else {
		// END PATROLLING
		if (_aiBase.EndPatrol())
		{
			// NETWORKING
			if (global.MultiplayerMode)
			{
				global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
			}
		}
	}
	return true;
}