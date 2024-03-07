function AIStateBanditPatrolResume(_aiBase)
{
	if (!global.MultiplayerMode)
	{
#region Offline
		if (_aiBase.instance_ref.path_position >= 1)
		{
			if (!_aiBase.ResumePatrol())
			{
				// TODO: Handle error
			}
		}
#endregion
	} else {
#region Multiplayer
#endregion		
	}
}