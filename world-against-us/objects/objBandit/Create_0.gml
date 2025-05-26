// INHERIT THE PARENT EVENT
event_inherited();

// INIT COLLIDER AND COLLISION BODY
var collisionBody = new CollisionBody(
	COLLISION_BODY_TYPE.Humanoid
);
collider = new Collider(
	COLLIDER_TYPE.Circle,
	sprite_width * 0.5, 
	-(bbox_bottom - bbox_top) * 0.5,
	collisionBody
);

// CHARACTER
character = new CharacterHuman("Bandit", CHARACTER_TYPE.Human, CHARACTER_RACE.humanoid, CHARACTER_BEHAVIOR.HOSTILE);

// AI STATES
aiStates = ds_map_create();
ds_map_add(aiStates, AI_STATE_BANDIT.PATROL, AIStateBanditPatrol);
ds_map_add(aiStates, AI_STATE_BANDIT.CHASE, AIStateBanditChase);
ds_map_add(aiStates, AI_STATE_BANDIT.PATROL_RETURN, AIStateBanditPatrolResume);
ds_map_add(aiStates, AI_STATE_BANDIT.PATROL_END, AIStateBanditPatrolEnd);

// AI
aiBandit = new AIEnemyBandit(self, aiStates, AI_STATE_BANDIT.PATROL, character, 2000, 1000, MetersToPixels(1));