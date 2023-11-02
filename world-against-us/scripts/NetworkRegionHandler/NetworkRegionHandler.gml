function NetworkRegionHandler() constructor
{
	region_id = undefined;
	room_index = undefined;
	owner_client = undefined;
	
	network_region_object_handler = new NetworkRegionObjectHandler();
	
	static ResetRegionData = function()
	{
		region_id = undefined;
		room_index = undefined;
		owner_client = undefined;
		
		network_region_object_handler.ResetRegionObjectData();
	}
}