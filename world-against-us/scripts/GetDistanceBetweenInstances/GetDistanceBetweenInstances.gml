function GetDistanceBetweenInstances(_instance1, _instance2)
{
	var distance = undefined;
	var instanceOriginPosition1 = GetInstanceOriginPosition(_instance1);
	var instanceOriginPosition2 = GetInstanceOriginPosition(_instance2);
	if (!is_undefined(instanceOriginPosition1) && !is_undefined(instanceOriginPosition2))
	{
		distance = point_distance(
			instanceOriginPosition1.X, instanceOriginPosition1.Y,
			instanceOriginPosition2.X, instanceOriginPosition2.Y
		);
	}
	return distance;
}