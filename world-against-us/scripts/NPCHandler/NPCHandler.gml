function NPCHandler() constructor
{
	npc_patrol_handler = new NPCPatrolHandler();
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.npc_patrol_handler);
		_struct.npc_patrol_handler = undefined;
	}
	
	static OnRoomEnd = function()
	{
		npc_patrol_handler.OnRoomEnd();
	}
}