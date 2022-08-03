if (global.ObjPlayer != noone)
{
	insideInteractionRange = (point_distance(x, y, global.ObjPlayer.x, global.ObjPlayer.y) < interactionRange);
	
	if (insideInteractionRange && keyboard_check_released(ord("F")))
	{
		loot.showInventory = !loot.showInventory;
		
		if (global.ObjLootContainer != noone)
		{
			with (global.ObjLootContainer)
			{
				loot = (other.loot.showInventory) ? other.loot : noone;
			}
		}
		
		if (global.PlayerBackpack != noone)
		{
			with (global.PlayerBackpack)
			{
				showInventory = other.loot.showInventory;	
			}
		}
	}
}
