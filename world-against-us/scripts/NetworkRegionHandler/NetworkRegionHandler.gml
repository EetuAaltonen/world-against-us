function NetworkRegionHandler() constructor
{
	// TODO: Replace with Region struct
	region_id = undefined;
	prev_region_id = undefined;
	room_index = undefined;
	owner_client = UNDEFINED_UUID;
	
	network_region_object_handler = new NetworkRegionObjectHandler();
	
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