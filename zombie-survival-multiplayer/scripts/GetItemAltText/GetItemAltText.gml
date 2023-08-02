function GetItemAltText(_item)
{
	var itemAltText = undefined;
	
	switch (_item.category)
	{
		case "Weapon":
		{
			if (_item.type != "Melee")
			{
				var ammoCapacity = _item.metadata.GetAmmoCapacity();
				if (ammoCapacity > 0)
				{
					var ammoCount = _item.metadata.GetAmmoCount();
					if (_item.metadata.chamber_type == "Fuel Tank")
					{
						itemAltText = string("{0}%", CeilToTwoDecimals(ammoCount / ammoCapacity) * 100);
					} else {
						itemAltText = string("{0} / {1}", ammoCount, ammoCapacity);
					}
				} else {
					itemAltText = "No Ammo"
				}
			}
		} break;
		case "Magazine":
		{
			itemAltText = string("{0} / {1}", _item.metadata.GetAmmoCount(), _item.metadata.GetAmmoCapacity());
		} break;
		case "Fuel Ammo":
		{
			itemAltText = string("{0}%", CeilToTwoDecimals(_item.metadata.GetAmmoCount() / _item.metadata.GetAmmoCapacity()) * 100);
		} break;
		case "Medicine":
		{
			itemAltText = string("{0} / {1}", _item.metadata.healing_left, _item.metadata.healing_value);
		} break;
		case "Fuel":
		{
			itemAltText = string("{0} / {1}", _item.metadata.fuel_left, _item.metadata.fuel_value);
		} break;
		default:
		{
			if (_item.max_stack > 1)
			{
				itemAltText = string("{0}x", _item.quantity);
			}
		} break;
	}
	
	return itemAltText;
}