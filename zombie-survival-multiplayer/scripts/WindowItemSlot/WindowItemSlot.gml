function WindowItemSlot(_elementId, _relativePosition, _size, _backgroundColor, _inventory, _callback_function_on_update_item = undefined) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	inventory = _inventory;
	initItem = true;
	callback_function_on_update_item = _callback_function_on_update_item;
	
	static UpdateContent = function()
	{
		if (initItem)
		{
			initItem = false;
			UpdateItem();
		}
		UpdateChildElements();
	}
	
	static UpdateItem = function()
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
							c_green, itemData.icon, 0, 1, 0
						)
					);
					AddChildElements(childImageElements);	
				}
				
				var childImageElement = childElements[| 0];
				childImageElement.spriteIndex = itemData.icon;
				childImageElement.initImage = true;
				
				if (!is_undefined(callback_function_on_update_item))
				{
					if (script_exists(callback_function_on_update_item))
					{
						script_execute(callback_function_on_update_item, itemData);
					}
				}
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
						initItem = true;
					}
				} else {
					var item = inventory.GetItemByIndex(0);
					if (global.ObjMouse.dragItem.sourceInventory.SwapWithRollback(global.ObjMouse.dragItem, item))
					{
						initItem = true;
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