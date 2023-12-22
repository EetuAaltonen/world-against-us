/// @description Custom RoomStartEvent
if (!is_undefined(structureId))
{
	var structureMetadata = new Metadata();
	structure = new Structure(structureId, INTERACTABLE_TYPE.Structure, STRUCTURE_CATEGORY.Garden, structureMetadata);
}