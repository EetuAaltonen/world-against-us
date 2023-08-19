function Structure(_structureId, _interactableType, _category, _metadata) constructor
{
	structure_id = _structureId;
	interactable_type = _interactableType;
	category = _category;
	metadata = _metadata;
	
	static ToJSONStruct = function()
	{
		var formatMetadata = (!is_undefined(metadata)) ? metadata.ToJSONStruct(metadata) : metadata;
									
		return {
			structure_id: structure_id,
			interactable_type: interactable_type,
			category: category,
			metadata: formatMetadata
		}
	}
}