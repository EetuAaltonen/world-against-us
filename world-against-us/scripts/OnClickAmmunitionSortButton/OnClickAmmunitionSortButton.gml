function OnClickAmmunitionSortButton()
{
	var facilityInventoryGrid = parentWindow.GetChildElementById("FacilityInventoryGrid");
	var inventoryItemCount = facilityInventoryGrid.inventory.GetItemCount();
	for (var i = 0; i < inventoryItemCount; i++)
	{
		var bulletItem = facilityInventoryGrid.inventory.GetItemByIndex(i);
		if (bulletItem.category == "Bullet")
		{
			for (var j = 0; j < inventoryItemCount; j++)
			{
				var magazineItem = facilityInventoryGrid.inventory.GetItemByIndex(j);
				if (magazineItem.category == "Magazine")
				{
					if (magazineItem.metadata.caliber == bulletItem.metadata.caliber)
					{
						var bulletCountToLoad = min((magazineItem.metadata.GetAmmoCapacity() - magazineItem.metadata.GetAmmoCount()), bulletItem.quantity);
						repeat(bulletCountToLoad)
						{
							magazineItem.metadata.ReloadAmmo(bulletItem.Clone(1));
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