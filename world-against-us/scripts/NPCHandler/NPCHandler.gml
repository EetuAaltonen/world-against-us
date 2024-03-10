function NPCHandler() constructor
{
	npc_patrol_handler = new NPCPatrolHandler();
	
	static OnDestroy = function(_struct = self)
	{
		DeleteStruct(_struct.npc_patrol_handler);
	}
	
	static OnRoomEnd = function()
	{
		npc_patrol_handler.OnRoomEnd();
	}
}