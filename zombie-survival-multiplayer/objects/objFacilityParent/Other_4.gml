if (!is_undefined(facility))
{
	facility.facility_id = facilityId;
	if (!is_undefined(facility.inventory))
	{
		facility.inventory.inventoryId = facilityId;
	}
}