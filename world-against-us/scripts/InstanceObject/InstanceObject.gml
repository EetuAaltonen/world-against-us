function InstanceObject(_sprite_index, _object_index, _position) constructor
{
	spr_index = _sprite_index;
	obj_index = _object_index;
	obj_name = object_get_name(obj_index);
	position = _position;
	
	instance_ref = noone;
	network_id = undefined;
	device_input_movement = new DeviceInputMovement(0, 0, 0, 0);
	
	// MOVEMENT INTERPOLATION
	start_position = undefined;
	target_position = undefined;
	interpolation_timer = new Timer(0);
	
	static ToJSONStruct = function()
	{
		// OVERRIDE THIS FUNCTION
		var scaledPosition = ScaleFloatValuesToIntVector2(position.X, position.Y);
		var formatPosition = (!is_undefined(scaledPosition)) ? scaledPosition.ToJSONStruct() : undefined;
		return {
			spr_index: spr_index,
			obj_index: obj_index,
			obj_name: obj_name,
			position: formatPosition
		}
	}
	
	static StartInterpolateMovement = function(_targetPosition, _interpolationTime)
	{
		start_position = position.Clone();
		target_position = _targetPosition;
		interpolation_timer.setting_time = _interpolationTime + (global.NetworkConnectionSamplerRef.ping ?? 0);
		interpolation_timer.StartTimer();
	}
	
	static InterpolateMovement = function()
	{
		if (!is_undefined(start_position) &&
			!is_undefined(target_position))
		{
			interpolation_timer.Update();
			
			var lerpPercent = 1 - (interpolation_timer.running_time / interpolation_timer.setting_time);
			position.X = lerp(start_position.X, target_position.X, lerpPercent);
			position.Y = lerp(start_position.Y, target_position.Y, lerpPercent);
			
			// UPDATE INSTANCE POSITION
			if (instance_exists(instance_ref))
			{
				instance_ref.x = position.X;
				instance_ref.y = position.Y;
			}
			
			// END MOVEMENT INTERPOLATION
			if (interpolation_timer.IsTimerStopped())
			{
				interpolation_timer.StopTimer();
				start_position = undefined;
				target_position = undefined;
			}
		}
	}
}