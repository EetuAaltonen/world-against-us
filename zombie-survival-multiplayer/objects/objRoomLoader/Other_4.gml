// LOAD CONTROLLERS TO A ROOM
var controllerCount = array_length(controllers);

show_debug_message("");
show_debug_message(string("**Loading controllers for '{0}'**", room_get_name(room)));

for (var i = 0; i < controllerCount; i++)
{
	var controller = controllers[@ i];
	
	if (instance_exists(controller.objectIndex))
	{
		// DESTROY IF CONTROLLER SHOULD BE DEACTIVE
		if (ArrayContainsValue(controller.deactiveRooms, room))
		{
			controller.RemoveInstance();
			instance_destroy(controller.objectIndex);
			continue;
		}
		
		// DESTROY IF CONTROLLER IS NOT IN RESTRICTED ROOM
		if (array_length(controller.restrictedRooms) > 0)
		{
			if (!ArrayContainsValue(controller.restrictedRooms, room))
			{
				controller.RemoveInstance();
				instance_destroy(controller.objectIndex);
				continue;
			}
		}
	} else {
		// SKIP IF CONTROLLER SHOULD BE DEACTIVE
		if (ArrayContainsValue(controller.deactiveRooms, room))
		{
			continue;
		}
		// SKIP IF CONTROLLER IS NOT IN RESTRICTED ROOM
		if (array_length(controller.restrictedRooms) > 0)
		{
			if (!ArrayContainsValue(controller.restrictedRooms, room))
			{
				continue;
			}
		}
		
		if (!layer_exists(controller.layerName)) {
			var layerDepth = controllerLayers[? controller.layerName] ?? depth;
			layer_create(layerDepth, controller.layerName);
		}
		var controllerInstance = instance_create_layer(-1, -1, controller.layerName, controller.objectIndex);
		controller.SetInstance(controllerInstance);
	}
	
	// CONSOLE LOG
	if (controller.instance != noone)
	{
		show_debug_message(string("->Instance loaded {0}", object_get_name(controller.objectIndex)));	
	}
}

// GO TO MAIN MENU AFTER LAUNCH
if (room == roomLaunch) { room_goto(roomMainMenu); }

// START ROOM FADE-IN EFFECT
roomFadeAlpha = roomFadeAlphaStart;