function ParseJSONStructToDatabaseWorldMapLocationData(_jsonStruct)
{
	var parsedWorldMapLocationData = undefined;
	try
	{
		if (is_undefined(_jsonStruct)) return parsedWorldMapLocationData;
		var mapLocationDataStruct = is_string(_jsonStruct) ? json_parse(_jsonStruct) : _jsonStruct;
		if (variable_struct_names_count(mapLocationDataStruct) <= 0) return parsedWorldMapLocationData;
			
		var roomIndex = mapLocationDataStruct[$ "room_index"] ?? undefined;
		var parsedName =  mapLocationDataStruct[$ "name"] ?? "Unknown";
		var parsedSize = ParseJSONStructToSize(mapLocationDataStruct[$ "size"] ?? undefined, false);
		var parsedPatrolPathIndex = asset_get_index(mapLocationDataStruct[$ "patrol_path"] ?? "Unknown");
		var parsedPatrolPath = (parsedPatrolPathIndex > -1) ? parsedPatrolPathIndex : undefined;
		
		switch (roomIndex)
		{
			case ROOM_INDEX_CAMP: { parsedWorldMapLocationData = new WorldMapLocation(roomCamp, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			
			case ROOM_INDEX_TOWN: { parsedWorldMapLocationData = new WorldMapLocation(roomTown, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			case ROOM_INDEX_OFFICE: { parsedWorldMapLocationData = new WorldMapLocation(roomOffice, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			case ROOM_INDEX_LIBRARY: { parsedWorldMapLocationData = new WorldMapLocation(roomLibrary, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			case ROOM_INDEX_MARKET: { parsedWorldMapLocationData = new WorldMapLocation(roomMarket, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			
			case ROOM_INDEX_FOREST: { parsedWorldMapLocationData = new WorldMapLocation(roomForest, roomIndex, parsedName, parsedSize, parsedPatrolPath); } break;
			default:
			{
				throw (string("Trying to parse an unknown world map location data with room index {0}", roomIndex));	
			}
		}
	} catch (error)
	{
		show_debug_message(error);
		show_message(error);
	}
	return parsedWorldMapLocationData;
}