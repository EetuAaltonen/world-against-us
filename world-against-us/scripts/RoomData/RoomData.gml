function RoomData(_roomName) constructor
{
	room_name = _roomName;
	
	static ToJSONStruct = function()
	{
		var roomStruct = EMPTY_STRUCT;
		var facilities = FetchFacilities();
		var roomDataStruct = {
			facilities: facilities
		}
		
		variable_struct_set(roomStruct, room_name, roomDataStruct);
		return roomStruct;
	}
	
	static FetchFacilities = function()
	{
		var facilityArray = [];
		var facilityInstanceCount = instance_number(objFacilityParent);
		for (var i = 0; i < facilityInstanceCount; i++)
		{
			var facilityInstance = instance_find(objFacilityParent, i);
			if (instance_exists(facilityInstance))
			{
				if (!is_undefined(facilityInstance.facility))
				{
					array_push(facilityArray, facilityInstance.facility.ToJSONStruct());
				}
			}
		}
		return facilityArray;
	}
}