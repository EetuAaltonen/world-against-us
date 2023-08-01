function GetItemAltText(_item)
{
	var itemAltText = undefined;
	
	switch (_item.category)
	{
		case "Weapon":
		{
			if (_item.type != "Melee")
			{
				if (_item.metadata.chamber_type == "Shell")
				{
					itemAltText = string("{0} / {1}", _item.metadata.GetShellCount(), _item.metadata.shell_capacity);
				} else if (_item.metadata.chamber_type == "Fuel Tank")
				{
					if (!is_undefined(_item.metadata.fuel_tank))
					{
						itemAltText = string("{0}%", ceil(_item.metadata.GetFuelLevel() / _item.metadata.fuel_tank.metadata.capacity) * 100);
					} else {
						itemAltText = "No Fuel"
					}
				}
			}
		} break;
		case "Magazine":
		{
			itemAltText = string("{0} / {1}", _item.metadata.GetBulletCount(), _item.metadata.capacity);
		} break;
		case "Fuel Tank":
		{
			itemAltText = string("{0}%", ceil(_item.metadata.fuel_level / _item.metadata.capacity) * 100);
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