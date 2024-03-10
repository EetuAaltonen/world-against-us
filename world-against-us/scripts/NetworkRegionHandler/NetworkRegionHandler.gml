function NetworkRegionHandler() constructor
{
	// TODO: Replace with Region struct
	region_id = undefined;
	prev_region_id = undefined;
	room_index = undefined;
	owner_client = UNDEFINED_UUID;
	
	network_region_remote_player_handler = new NetworkRegionRemotePlayerHandler();
	network_region_object_handler = new NetworkRegionObjectHandler();
	
	static OnDestroy = function(_struct = self)
	{
		DeleteStruct(_struct.network_region_remote_player_handler);
		DeleteStruct(_struct.network_region_object_handler);
	}
	
	static Update = function()
	{
		network_region_remote_player_handler.Update();
		network_region_object_handler.Update();
	}
	
	static IsClientRegionOwner = function()
	{
		return (global.NetworkHandlerRef.client_id == owner_client);
	}
	
	static ResetRegionData = function()
	{
		region_id = undefined;
		prev_region_id = undefined;
		room_index = undefined;
		owner_client = UNDEFINED_UUID;
		
		network_region_object_handler.ResetRegionObjectData();
	}
	
	static OnRoomEnd = function()
	{
		network_region_remote_player_handler.OnRoomEnd();
		network_region_object_handler.OnRoomEnd();
	}
	
	static Draw = function()
	{
		network_region_remote_player_handler.Draw();
	}
}