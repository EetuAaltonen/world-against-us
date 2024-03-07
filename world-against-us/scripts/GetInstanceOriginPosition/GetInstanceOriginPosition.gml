function GetInstanceOriginPosition(_instance)
{
	var originPosition = undefined;
	if (instance_exists(_instance))
	{
		var instanceOriginX = (_instance.bbox_left + ((_instance.bbox_right - _instance.bbox_left) * 0.5));
		var instanceOriginY = max(_instance.y, _instance.bbox_bottom);
		originPosition = new Vector2(instanceOriginX, instanceOriginY);
	}
	return originPosition;
}