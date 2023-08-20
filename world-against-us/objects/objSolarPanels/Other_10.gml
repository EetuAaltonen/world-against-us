/// @description Custom RoomStartEvent
if (!is_undefined(structureId))
{
	var structureMetadata = new MetadataStructureSolarPanel();
	structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.SolarPanel, structureMetadata);
}