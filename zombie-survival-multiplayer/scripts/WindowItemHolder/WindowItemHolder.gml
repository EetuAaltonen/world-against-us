function WindowItemHolder(_elementId, _relativePosition, _size, _backgroundColor, _inventory) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	inventory = _inventory;
	initItemHolder = true;
	
	static UpdateContent = function()
	{
		if (initItemHolder)
		{
			initItemHolder = false;
			SetItem();
		}
		UpdateChildElements();
	}
	
	static SetItem = function()
	{
		if (inventory.GetItemCount() > 0)
		{
			var itemData = inventory.GetItemByIndex(0);
			if (!is_undefined(itemData))
			{
				if (ds_list_size(childElements) <= 0)
				{
					var childImageElements = ds_list_create();
					ds_list_add(childImageElements,
						new WindowImage(
							string("{0}Image", elementId),
							new Vector2(2, 2), new Size(size.w - 4, size.h - 4),
							c_green, itemData.icon
						)
					);
					AddChildElements(childImageElements);	
				}
				
				var childImageElement = childElements[| 0];
				childImageElement.spriteIndex = itemData.icon;
				childImageElement.initImage = true;
			}
		}
	}
	
	static CheckContentInteraction = function()
	{
		// CHECK FOR INTERACTIONS
		if (!is_undefined(global.ObjMouse.dragItem))
		{
			if (mouse_check_button_released(mb_left))
			{
				if (inventory.GetItemCount() <= 0)
				{
					if (inventory.AddItem(global.ObjMouse.dragItem.Clone()))
					{
						global.ObjMouse.dragItem.sourceInventory.RemoveItemByGridIndex(global.ObjMouse.dragItem.grid_index);
						SetItem();
					}
				}
				global.ObjMouse.dragItem = undefined;
			}
		} else {
			if (mouse_check_button_pressed(mb_left))
			{
				if (inventory.GetItemCount() > 0)
				{
					var item = inventory.GetItemByIndex(0);
					global.ObjMouse.dragItem = item.Clone();
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		if (ds_list_size(childElements) > 0)
		{
			if (inventory.GetItemCount() > 0)
			{
				var itemDragged = false;
				if (!is_undefined(global.ObjMouse.dragItem))
				{
					var item = inventory.GetItemByIndex(0);
					if (global.ObjMouse.dragItem.sourceInventory.inventoryId == item.sourceInventory.inventoryId)
					{
						itemDragged = (item.grid_index.col == global.ObjMouse.dragItem.grid_index.col && item.grid_index.row == global.ObjMouse.dragItem.grid_index.row);
					}
				}
				var windowImage = childElements[| 0];
				windowImage.imageAlpha = itemDragged ? 0 : 1;
				windowImage.Draw();
			}
		}
	}
}