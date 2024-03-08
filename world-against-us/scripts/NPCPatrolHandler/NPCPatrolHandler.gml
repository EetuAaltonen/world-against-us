function NPCPatrolHandler() constructor
{
	local_patrols = ds_map_create();
	
	static OnDestroy = function(_struct = self)
	{
		DestroyDSMapAndDeleteValues(_struct.local_patrols);
		local_patrols = undefined;
	}
	
	static AddPatrol = function(_patrol)
	{
		var isPatrolAdded = false;
		if (!is_undefined(_patrol))
		{
			isPatrolAdded = ds_map_add(local_patrols, _patrol.patrol_id, _patrol);
		}
		return isPatrolAdded;
	}
	
	static SpawnPatrol = function(_patrol)
	{
		var isPatrolSpawned = false;
		if (!is_undefined(_patrol))
		{
			// INITIALIZE PATROL ROUTE
			_patrol.InitRoute();
			
			// SPAWN BANDIT INSTANCE
			var banditInstance = instance_create_layer(0, 0, LAYER_CHARACTERS, objBandit);
			
			// SET PATROL TO INSTANCE AI BASE
			banditInstance.aiBandit.patrol = _patrol;
			
			// SET INSTANCE REF TO PATROL
			_patrol.instance_ref = banditInstance;
			isPatrolSpawned = true;
		}
		return isPatrolSpawned;
	}
	
	static GetPatrol = function(_patrolId)
	{
		return local_patrols[? _patrolId] ?? undefined;
	}
	
	static SyncPatrolState = function(_patrolState)
	{
		var isStateSynced = false;
		if (!is_undefined(_patrolState))
		{
			var patrol = GetPatrol(_patrolState.patrol_id);
			if (!is_undefined(patrol))
			{
				isStateSynced = patrol.SyncState(_patrolState);
			} else {
				var newPatrol = new Patrol(_patrolState.patrol_id, AI_STATE_BANDIT.TRAVEL, 0, 0);
				if (AddPatrol(newPatrol))
				{
					if (SpawnPatrol(newPatrol))
					{
						isStateSynced = newPatrol.SyncState(_patrolState);
					}
				}
			}
		}
		return isStateSynced;
	}
	
	static DeletePatrol = function(_patrolId)
	{
		var patrol = GetPatrol(_patrolId);
		if (!is_undefined(patrol))
		{
			DeleteStruct(patrol);
		}
		ds_map_delete(local_patrols, _patrolId);	
	}
}