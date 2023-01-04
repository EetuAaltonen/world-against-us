function ElectricalNetwork(_electricId, _targetId, _maxElectricOutputPower) constructor
{
	electricId = _electricId;
	targetId = _targetId;
	targetInstance = noone;
	maxElectricOutputPower = _maxElectricOutputPower;
	electricOutputPower = 0;
	electricPower = 0;
	initNetwork = true;
	
	static Update = function()
	{
		if (initNetwork)
		{
			initNetwork = false;
			if (!is_undefined(targetId))
			{
				var instanceCount = instance_number(objFacility);
				for (var i = 0; i < instanceCount; ++i;)
				{
					var facilityInstance = instance_find(objFacility, i);
					if (instance_exists(facilityInstance))
					{
						if (!is_undefined(facilityInstance.electricalNetwork))
						{
							if (facilityInstance.electricalNetwork.electricId == targetId)
							{
								targetInstance = facilityInstance;
								break;
							}
						}
					}
				}
			}
		}
		
		if (targetInstance != noone)
		{
			targetInstance.electricalNetwork.electricPower = max(electricPower, electricOutputPower);
		}
	}
	
	static Draw = function(_wireStartPos)
	{
		if (targetInstance != noone)
		{
			var wireEndPos = new Vector2(targetInstance.x, targetInstance.y);
			var wireColor = (max(electricPower, electricOutputPower) > 0) ? c_blue : c_black;
	
			draw_set_color(wireColor);
			draw_line_width(_wireStartPos.X, _wireStartPos.Y, wireEndPos.X, wireEndPos.Y, 2);
	
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}