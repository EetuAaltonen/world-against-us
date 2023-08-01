function ItemActionEmptyPrimaryWeapon(_item)
{
	switch (_item.type)
	{
		case "Melee": {
			// SKIP
		} break;
		case "Flamethrower": {
			if (_item.sourceInventory.AddItem(_item.metadata.fuel_tank))
			{
				_item.metadata.fuel_tank = undefined;
			}
		} break;
		default: {
			if (_item.sourceInventory.AddItem(_item.metadata.magazine))
			{
				_item.metadata.magazine = undefined;
			}
		} break;
	}
}