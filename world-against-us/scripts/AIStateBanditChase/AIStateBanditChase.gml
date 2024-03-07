function AIStateBanditChase(_aiBase)
{
	if (!global.MultiplayerMode)
	{
#region Offline
		_aiBase.path_update_timer.Update();
		if(_aiBase.path_update_timer.IsTimerStopped() || (_aiBase.instance_ref.path_position >= 1))
		{
			var targetInstancePosition = GetInstanceOriginPosition(_aiBase.target_instance);
			if (!is_undefined(targetInstancePosition))
			{
				var targetCharacter = _aiBase.target_instance.character;
				if (!is_undefined(targetCharacter))
				{
					// CHECK IF TARGET CAN BE TARGETED
					if (!targetCharacter.IsInvulnerableState())
					{
						if (_aiBase.IsTargetInCloseRange())
						{
							// SET TARGET BEING ROBBED
							targetCharacter.is_robbed = true;
							
							// TRIGGER LOCAL PLAYER ON ROBBED
							if (targetCharacter.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
							{
								global.PlayerDataHandlerRef.OnRobbed();
							}
							
							// RETURN TO PATROL
							_aiBase.ReturnToPatrol();
						} else {
							var distanceToTarget = GetDistanceBetweenInstances(_aiBase.instance_ref, _aiBase.target_instance);
							if (distanceToTarget <= _aiBase.path_update_threshold)
							{
								// SET TARGET INSTANCE
								_aiBase.SetTargetInstance(_aiBase.target_instance);
								
								// CALCULATE POTENTIAL PATHING
								if (!_aiBase.StartPathingToTarget(true))
								{
									// RETURN TO PATROL
									_aiBase.ReturnToPatrol();	
								}
							} else {
								var pathToTargetEndX = path_get_x(_aiBase.path_to_target.path, 1);
								var pathToTargetEndY = path_get_y(_aiBase.path_to_target.path, 1);
								var distanceToTargetPathEnd = point_distance(pathToTargetEndX, pathToTargetEndY, targetInstancePosition.X, targetInstancePosition.Y);
								if (distanceToTargetPathEnd > _aiBase.path_update_threshold)
								{
									if (_aiBase.IsTargetInVisionRadius())
									{
										// SET TARGET INSTANCE
										_aiBase.SetTargetInstance(_aiBase.target_instance);
									
										// RECALCULATE PATHING
										if (!_aiBase.StartPathingToTarget())
										{
											// RETURN TO PATROL
											_aiBase.ReturnToPatrol();
										}
									} else {
										// RETURN TO PATROL
										_aiBase.ReturnToPatrol();
									}
								}
							}
							// START PATH UPDATE TIMER
							_aiBase.path_update_timer.StartTimer();
						}
					} else {
						// RETURN TO PATROL
						_aiBase.ReturnToPatrol();
					}
				} else {
					// RETURN TO PATROL
					_aiBase.ReturnToPatrol();
				}
			} else {
				// RETURN TO PATROL
				_aiBase.ReturnToPatrol();
			}
		}
#endregion
	} else {
#region Multiplayer
		if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
		{
			// NETWORKING
			/*var patrolState = new PatrolState(
				global.NetworkRegionHandlerRef.region_id,
				patrolId, aiState,
				patrolRouteProgress,
				new Vector2(x, y),
				targetPosition
			);
			BroadcastPatrolState(patrolState);*/
									
			// NETWORKING
			/*var patrolState = new PatrolState(
				global.NetworkRegionHandlerRef.region_id,
				patrolId, aiState,
				patrolRouteProgress,
				new Vector2(x, y),
				new Vector2(patrolPathLastPosition.X, patrolPathLastPosition.Y)
			);
			BroadcastPatrolState(patrolState);*/
		}
#endregion
	}
}