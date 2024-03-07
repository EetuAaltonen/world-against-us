function AIStateBanditPatrol(_aiBase)
{
	// UPDATE PATROL ROUTE PROGRESS
	_aiBase.UpdatePatrolRouteProgress();
	
	if (!global.MultiplayerMode)
	{
#region Offline
		// CHECK PATROL ROUTE END
		if (_aiBase.patrol_route_progress < 1)
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
					// UPDATE PATROL ROUTE PROGRESS
					_aiBase.patrol_route_progress = _aiBase.instance_ref.path_position;
					
					// START CHASE
					if (_aiBase.StartChasingTarget(targetInstanceInVision))
					{
						// START PATH UPDATE TIMER
						_aiBase.path_update_timer.StartTimer();
					} else {
						// TODO: Handle error
					}
				} else {
					// TODO: Handle target lost
				}
			}
		} else {
			// END PATROLLING
			_aiBase.EndPatrol();
		}
#endregion
	} else {
#region Multiplayer
		if (!global.NetworkRegionHandlerRef.IsClientRegionOwner())
		{
			// CHECK PATROL ROUTE END
			if (_aiBase.patrol_route_progress < 1)
			{
				_aiBase.target_seek_timer.Update();
				if (_aiBase.target_seek_timer.IsTimerStopped())
				{
					// SEEK TARGET
					var targetInstanceInVision = _aiBase.SeekTargetInVision(objPlayer);
					if (instance_exists(targetInstanceInVision))
					{
						// START CHASE
						if (_aiBase.StartChasingTarget(targetInstanceInVision))
						{
							// NETWORKING
							var patrolState = new PatrolState(
								global.NetworkRegionHandlerRef.region_id,
								patrolId, aiState,
								patrolRouteProgress,
								new Vector2(x, y),
								targetPosition
							);
							BroadcastPatrolState(patrolState);
						} else {
							// TODO: Handle error	
						}
					}
				
					// RESTART TARGET SEEK TIMER
					_aiBase.target_seek_timer.StartTimer();
				}
			}  else {
				// END PATROLLING
				//_aiBase.EndPatrol();
			}
		}
#endregion
	}
	
	return true;
}