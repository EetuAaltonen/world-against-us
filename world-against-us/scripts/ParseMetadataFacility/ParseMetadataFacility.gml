function ParseMetadataFacility(_metadata, _facilityType)
{
	var parsedMetadata = new Metadata();
	if (!is_undefined(_metadata) && !is_undefined(_facilityType))
	{
		switch (_facilityType)
		{
			case "Generator":
			{
				parsedMetadata = new MetadataFacilityGenerator(
					_metadata[$ "fuel_tank_capacity"],
					_metadata[$ "fuel_level"]
				);
			} break;
			case "Road_Gate":
			{
				parsedMetadata = new MetadataFacilityRoadGate(
					_metadata[$ "is_open"],
				);
			} break;
		}
	}
	return parsedMetadata;
}