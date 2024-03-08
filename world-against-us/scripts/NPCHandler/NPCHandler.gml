function NPCHandler() constructor
{
	npc_patrol_handler = new NPCPatrolHandler();
	
	static OnDestroy = function(_struct = self)
	{
		DeleteStruct(npc_patrol_handler);
	}
}