function AIStateBanditPatrolResume(_aiBase)
{
	// UPDATE PATROL POSITION
	_aiBase.UpdatePatrolPosition();
	
	if (!global.MultiplayerMode)
	{
#region Offline
		if (_aiBase.instance_ref.path_position >= 1)
		{
			// RESUME PATROL
			_aiBase.ResumePatrol();
		}
#endregion
	} else {
#region Multiplayer
		if (global.NetworkRegionHandlerRef.IsClientRegionOwner())
		{
			if (_aiBase.instance_ref.path_position >= 1)
			{
				// RESUME PATROL
				if (_aiBase.ResumePatrol()) global.NetworkRegionObjectHandlerRef.BroadcastPatrolState(_aiBase);
			}
		}
#endregion		
	}
}