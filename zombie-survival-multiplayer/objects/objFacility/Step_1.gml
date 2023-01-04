if (!is_undefined(electricalNetwork))
{
	if (electricalNetwork.targetInstance == noone)
	{
		if (electricalNetwork.initNetwork)
		{
			initNetwork = false;
			if (!is_undefined(electricalNetwork.targetId))
			{
				var instanceCount = instance_number(objFacility);
				for (var i = 0; i < instanceCount; ++i;)
				{
					var facilityInstance = instance_find(objFacility, i);
					if (instance_exists(facilityInstance))
					{
						if (!is_undefined(facilityInstance.electricalNetwork))
						{
							if (facilityInstance.electricalNetwork.electricId == electricalNetwork.targetId)
							{
								electricalNetwork.targetInstance = facilityInstance;
								break;
							}
						}
					}
				}
			}
		}
	} else {
		var targetInstance = electricalNetwork.targetInstance;
		targetInstance.electricalNetwork.electricPower = max(electricalNetwork.electricPower, electricalNetwork.electricOutputPower);
	}
}