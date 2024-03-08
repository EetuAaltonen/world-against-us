function NetworkRegionHandler() constructor
{
	// TODO: Replace with Region struct
	region_id = undefined;
	prev_region_id = undefined;
	room_index = undefined;
	owner_client = UNDEFINED_UUID;
	
	network_region_object_handler = new NetworkRegionObjectHandler();
	
	static OnDestroy = function()
	{
		network_region_object_handler.OnDestroy();
		network_region_object_handler = undefined;
	}
	
	static Update = function()
	{
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
		network_region_object_handler.OnRoomEnd();
	}
}