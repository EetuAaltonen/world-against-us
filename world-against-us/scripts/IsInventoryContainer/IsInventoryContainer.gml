function IsInventoryContainer(_inventoryType)
{
	return (
		_inventoryType == INVENTORY_TYPE.LootContainer ||
		_inventoryType == INVENTORY_TYPE.StorageContainer
	);
}