function GetStructureId(_structureInstance)
{
	var structureId = undefined;
	
	if (instance_exists(_structureInstance))
	{
		var objectName = object_get_name(_structureInstance.object_index);
		if (objectName != UNDEFINED_OBJECT_NAME)
		{
			var scaledPosition = ScaleFloatValuesToIntVector2(x, y);
			structureId = string("{0}_{1}_{2}", objectName, scaledPosition.X, scaledPosition.Y);
		}
	}
	
	return structureId;
}