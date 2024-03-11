function AIStateBanditChase(_aiBase)
{
	// UPDATE PATROL POSITION
	_aiBase.UpdatePatrolPosition();
	
	if (!global.MultiplayerMode)
	{
#region Offline
		_aiBase.path_update_timer.Update();
		if(_aiBase.path_update_timer.IsTimerStopped() || (_aiBase.instance_ref.path_position >= 1))
		{
			// RESTART PATH UPDATE TIMER
			_aiBase.path_update_timer.StartTimer();
			
			var targetInstancePosition = GetInstanceOriginPosition(_aiBase.target_instance);
			if (!is_undefined(targetInstancePosition))
			{
				if (!IsInstanceCharacterInvulnerable(_aiBase.target_instance))
				{
					if (_aiBase.IsTargetInCloseRange())
					{
						var targetCharacter = _aiBase.target_instance.character;
						if (!is_undefined(targetCharacter))
						{
							// TRIGGER LOCAL PLAYER ON ROBBED
							if (targetCharacter.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
							{
								global.PlayerDataHandlerRef.OnRobbed();
							}
						}
						// RETURN TO PATROL
						_aiBase.ReturnToPatrol();
					} else {
						var distanceToTarget = GetDistanceBetweenInstances(_aiBase.instance_ref, _aiBase.target_instance);
						if (distanceToTarget <= _aiBase.path_update_threshold)
						{
							// SET TARGET INSTANCE
							_aiBase.SetTargetInstance(_aiBase.target_instance);
								
							// RECALCULATE PATH TO TARGET
							if (!_aiBase.StartPathingToTarget(true))
							{
								// RETURN TO PATROL
								_aiBase.ReturnToPatrol();
							}
						} else {
							var pathEndPoint = _aiBase.path_to_target.GetPathPoint(1);
							if (!is_undefined(pathEndPoint))
							{
								var distanceToTargetPathEnd = point_distance(
									pathEndPoint.X, pathEndPoint.Y,
									targetInstancePosition.X, targetInstancePosition.Y
								);
								if (distanceToTargetPathEnd > _aiBase.path_update_threshold)
								{
									if (_aiBase.IsTargetInVisionRadius())
									{
										// SET TARGET INSTANCE
										_aiBase.SetTargetInstance(_aiBase.target_instance);
										
										// RECALCULATE PATH TO TARGET
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
						}
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
		_aiBase.path_update_timer.Update();
		if(_aiBase.path_update_timer.IsTimerStopped() || (_aiBase.instance_ref.path_position >= 1))
		{
			// RESTART PATH UPDATE TIMER
			_aiBase.path_update_timer.StartTimer();
			
			var targetInstancePosition = GetInstanceOriginPosition(_aiBase.target_instance);
			if (!is_undefined(targetInstancePosition))
			{
				if (!IsInstanceCharacterInvulnerable(_aiBase.target_instance))
				{
					if (_aiBase.IsTargetInCloseRange())
					{
						// NETWORKING
						if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
						{
							var targetCharacter = _aiBase.target_instance.character;
							if (!is_undefined(targetCharacter))
							{
								// TRIGGER LOCAL PLAYER ON ROBBED
								if (targetCharacter.behaviour == CHARACTER_BEHAVIOUR.PLAYER)
								{
									global.PlayerDataHandlerRef.OnRobbed();
								}
								
								// BROADCAST ROB ACTION
								global.NetworkRegionObjectHandlerRef.BroadcastPatrolActionRob(_aiBase);
							}
							// RETURN TO PATROL
							if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
						}
					} else {
						var distanceToTarget = GetDistanceBetweenInstances(_aiBase.instance_ref, _aiBase.target_instance);
						if (distanceToTarget <= _aiBase.path_update_threshold)
						{
							// SET TARGET INSTANCE
							_aiBase.SetTargetInstance(_aiBase.target_instance);
								
							// RECALCULATE PATH TO TARGET
							if (!_aiBase.StartPathingToTarget(true))
							{
								// NETWORKING
								if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
								{
									// RETURN TO PATROL
									if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
								}
							}
						} else {
							var pathEndPoint = _aiBase.path_to_target.GetPathPoint(1);
							if (!is_undefined(pathEndPoint))
							{
								var distanceToTargetPathEnd = point_distance(
									pathEndPoint.X, pathEndPoint.Y,
									targetInstancePosition.X, targetInstancePosition.Y
								);
								if (distanceToTargetPathEnd > _aiBase.path_update_threshold)
								{
									if (_aiBase.IsTargetInVisionRadius())
									{
										// SET TARGET INSTANCE
										_aiBase.SetTargetInstance(_aiBase.target_instance);
										
										// RECALCULATE PATH TO TARGET
										if (!_aiBase.StartPathingToTarget())
										{
											// NETWORKING
											if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
											{
												// RETURN TO PATROL
												if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
											}
										}
									} else {
										// NETWORKING
										if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
										{
											// RETURN TO PATROL
											if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
										}
									}
								}
							}
						}
					}
				} else {
					// NETWORKING
					if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
					{
						// RETURN TO PATROL
						if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
					}
				}
			} else {
				// NETWORKING
				if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
				{
					// RETURN TO PATROL
					if (_aiBase.ReturnToPatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
				}
			}
		}
#endregion
	}
}