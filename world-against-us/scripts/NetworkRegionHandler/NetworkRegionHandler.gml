function NetworkRegionHandler() constructor
{
	region_id = undefined;
	room_index = undefined;
	owner_client = undefined;
	
	static ResetRegionData = function()
	{
		region_id = undefined;
		room_index = undefined;
		owner_client = undefined;
	}
}