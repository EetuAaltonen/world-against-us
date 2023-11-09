function NetworkRegionObjectHandler() constructor
{
	active_inventory_stream = undefined;
	
	static ValidateRegionContainers = function()
	{
		var isContainersValid = true;
		var existContainerIds = [];
		var containerCount = instance_number(objContainerParent);
		for (var i = 0; i < containerCount; ++i;)
		{
			var containerInstance = instance_find(objContainerParent, i);
			if (!is_undefined(containerInstance))
			{
				// TODO: Check if container has 'containerId' and 'lootTableTag' properties
				if (!array_contains(existContainerIds, containerInstance.containerId))
				{
					array_push(existContainerIds, containerInstance.containerId);
				} else {
					isContainersValid = false;
					show_debug_message(string("Duplicate container ID {0} type of {1}", containerInstance.containerId, containerInstance.lootTableTag));
				}
			}
		}
		return isContainersValid;
	}
}