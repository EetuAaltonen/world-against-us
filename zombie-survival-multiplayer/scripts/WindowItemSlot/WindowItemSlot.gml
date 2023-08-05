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
				// CREATE WINDOW ELEMENTS
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
			var dragItemData = global.ObjMouse.dragItem.item_data;
			if (mouse_check_button_released(mb_left))
			{
				if (inventory.GetItemCount() <= 0)
				{
					if (inventory.AddItem(dragItemData, undefined, false))
					{
						initItem = true;
					}
				} else {
					// SWAP EQUIPPED ITEM WITH ROLLBACK
					var item = inventory.GetItemByIndex(0);
					if (dragItemData.sourceInventory.AddItem(item))
					{
						inventory.RemoveItemByIndex(0);
						inventory.AddItem(dragItemData, undefined, false);
						initItem = true;
					} else {
						// RESTORE ITEM IF SWAPPING IS INTERRUPTED
						global.ObjMouse.dragItem.RestoreOriginalItem();
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
					OnPressedGUIDragItemStart(item);
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
				var windowImage = childElements[| 0];
				windowImage.imageAlpha = 1;
				windowImage.Draw();
			}
		}
	}
}