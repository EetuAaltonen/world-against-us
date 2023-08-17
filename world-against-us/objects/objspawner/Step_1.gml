if (instance_exists(global.ObjNetwork))
{
	if (instance_exists(global.InstancePlayer))
	{
		var client = global.ObjNetwork.client;
		if (!client.isPlayerDataSynced)
		{
			client.SyncPlayerData();
		}
	}
}
