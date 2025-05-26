// INHERIT THE PARENT EVENT
event_inherited();

// INIT COLLIDER AND COLLISION BODY
var collisionBody = new CollisionBody(
	COLLISION_BODY_TYPE.Zombie
);
collider = new Collider(
	COLLIDER_TYPE.Circle,
	sprite_width * 0.5, 
	-(bbox_bottom - bbox_top) * 0.5,
	collisionBody
);

// CHARACTER
character = new CharacterZombie("Zombie", CHARACTER_TYPE.Zombie, CHARACTER_RACE.undead, CHARACTER_BEHAVIOR.HOSTILE, collider);

// AI STATES
aiStates = ds_map_create();
ds_map_add(aiStates, AI_STATE_ZOMBIE.IDLE, AIStateZombieIdle);
ds_map_add(aiStates, AI_STATE_ZOMBIE.WANDER, AIStateZombieWander);
ds_map_add(aiStates, AI_STATE_ZOMBIE.SEARCH, AIStateZombieDead);
ds_map_add(aiStates, AI_STATE_ZOMBIE.CHASE, AIStateZombieDead);
ds_map_add(aiStates, AI_STATE_ZOMBIE.ON_DEAD, AIStateZombieOnDead);
ds_map_add(aiStates, AI_STATE_ZOMBIE.DEAD, AIStateZombieDead);
/*ds_map_add(aiStates, AI_STATE_BANDIT.PATROL, AIStateBanditPatrol);
ds_map_add(aiStates, AI_STATE_BANDIT.CHASE, AIStateBanditChase);
ds_map_add(aiStates, AI_STATE_BANDIT.PATROL_RETURN, AIStateBanditPatrolResume);
ds_map_add(aiStates, AI_STATE_BANDIT.PATROL_END, AIStateBanditPatrolEnd);*/

// AI
aiBase = new AIEnemyZombie(self, aiStates, AI_STATE_ZOMBIE.IDLE, character, collider, 2000, 1000, MetersToPixels(1));