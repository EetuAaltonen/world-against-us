enum MESSAGE_TYPE
{
	// TODO: Rename 'OTHER' prefix with 'REMOTE'
	ACKNOWLEDGMENT,
	CONNECT_TO_HOST,
	OTHER_CONNECTED_TO_HOST,
	PING,
	PONG,
	DISCONNECT_FROM_HOST,
	OTHER_DISCONNECT_FROM_HOST,
	
	REQUEST_JOIN_GAME,
	SYNC_WORLD_STATE,
	SYNC_WORLD_STATE_WEATHER,
	
	REQUEST_PLAYER_LIST,
	DATA_PLAYER_SYNC,
	PLAYER_DATA_POSITION,
	DATA_PLAYER_VELOCITY,
	PLAYER_DATA_MOVEMENT_INPUT,
	DATA_PLAYER_WEAPON_FUNCTION,
	DATA_PLAYER_WEAPON_EQUIP,
	
	REQUEST_INSTANCE_LIST,
	REQUEST_FAST_TRAVEL,
	SYNC_INSTANCE,
	
	REQUEST_CONTAINER_CONTENT,
	START_CONTAINER_INVENTORY_STREAM,
	CONTAINER_INVENTORY_STREAM,
	END_CONTAINER_INVENTORY_STREAM,
	CONTAINER_INVENTORY_ADD_ITEM,
	CONTAINER_INVENTORY_STACK_ITEM,
	CONTAINER_INVENTORY_IDENTIFY_ITEM,
	CONTAINER_INVENTORY_ROTATE_ITEM,
	CONTAINER_INVENTORY_REMOVE_ITEM,
	RELEASE_CONTAINER_CONTENT,
	
	PATROL_STATE,
	PATROLS_DATA_PROGRESS_POSITION,
	
	REQUEST_SCOUT_LIST,
	START_OPERATIONS_SCOUT_STREAM,
	OPERATIONS_SCOUT_STREAM,
	END_OPERATIONS_SCOUT_STREAM,
	
	SYNC_SCOUTING_DRONE_DATA,
	SCOUTING_DRONE_DATA_POSITION,
	DESTROY_SCOUTING_DRONE_DATA,
	
	INVALID_REQUEST,
	SERVER_ERROR,
	CLIENT_ERROR,
	
	// ENUM LENGHT
	ENUM_LENGTH
}