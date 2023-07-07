function OnClickAmmunitionSortButton()
{
	var facilityInventoryGrid = parentWindow.GetChildElementById("FacilityInventoryGrid");
	var inventoryItemCount = facilityInventoryGrid.inventory.GetItemCount();
	for (var i = 0; i < inventoryItemCount; i++)
	{
		var bulletItem = facilityInventoryGrid.inventory.GetItemByIndex(i);
		if (bulletItem.type == "Bullet")
		{
			for (var j = 0; j < inventoryItemCount; j++)
			{
				var magazineItem = facilityInventoryGrid.inventory.GetItemByIndex(j);
				if (magazineItem.type == "Magazine")
				{
					if (magazineItem.metadata.caliber == bulletItem.metadata.caliber)
					{
						var bulletCountToLoad = min((magazineItem.metadata.capacity - magazineItem.metadata.GetBulletCount()), bulletItem.quantity);
						repeat(bulletCountToLoad)
						{
							var bulletToLoad = bulletItem.Clone(1)
							bulletToLoad.sourceInventory = undefined;
							
							magazineItem.metadata.LoadBullet(bulletToLoad);
							bulletItem.quantity -= 1;
						}
						
						if (bulletItem.quantity <= 0)
						{
							bulletItem.sourceInventory.RemoveItemByGridIndex(bulletItem.grid_index);
							// UPDATE INVENTORY ITEM COUNT
							inventoryItemCount = facilityInventoryGrid.inventory.GetItemCount();
							break;
						}
					}
				}
			}
		}
	}
}