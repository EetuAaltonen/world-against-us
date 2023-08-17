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
		var itemData = inventory.GetItemByIndex(0);
		if (!is_undefined(itemData))
		{
			if (!is_undefined(callback_function_on_update_item))
			{
				if (script_exists(callback_function_on_update_item))
				{
					script_execute(callback_function_on_update_item, itemData);
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
				// CHECK IF ITEM IS WHITELISTED
				if (inventory.GetItemCount() <= 0)
				{
					if (inventory.IsItemWhiteListed(dragItemData))
					{
						var addedItemGridIndex = inventory.AddItem(dragItemData, undefined, false);
						if (!is_undefined(addedItemGridIndex))
						{
							initItem = true;
						} else {
							// RESTORE ITEM IF ITEM CATEGORY IS WRONG
							global.ObjMouse.dragItem.RestoreOriginalItem();
						}
					} else {
						// RESTORE ITEM IF ITEM CATEGORY IS WRONG
						global.ObjMouse.dragItem.RestoreOriginalItem();
					}
				} else {
					// ITEM DROP ACTIONS
					var slottedItem = inventory.GetItemByIndex(0);
					if (!is_undefined(slottedItem))
					{
						if (CombineItems(dragItemData, slottedItem))
						{
							initItem = true;
						} else {
							if (inventory.IsItemWhiteListed(dragItemData))
							{
								// SWAP EQUIPPED ITEM WITH ROLLBACK
								if (dragItemData.sourceInventory.SwapWithRollback(dragItemData, slottedItem))
								{
									initItem = true;
								}
							}  else {
								// RESTORE ITEM IF SWAPPING IS INTERRUPTED
								global.ObjMouse.dragItem.RestoreOriginalItem();
							}
						}
					}
				}
				global.ObjMouse.dragItem = undefined;
			}
		} else {
			if (mouse_check_button_pressed(mb_left))
			{
				var itemData = inventory.GetItemByIndex(0);
				if (!is_undefined(itemData))
				{
					OnPressedGUIDragItemStart(itemData);
				}
			} else if (mouse_check_button_released(mb_right))
			{
				var itemData = inventory.GetItemByIndex(0);
				if (!is_undefined(itemData))
				{
					GUIOpenItemActionMenu(itemData);
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		var baseIconScale = 0.9;
		var imageAlpha = 1;
		var itemData = inventory.GetItemByIndex(0);
		
		if (!is_undefined(itemData))
		{
			DrawItem(
				itemData, 0, baseIconScale, imageAlpha,
				new Vector2(position.X + (size.w * 0.5), position.Y + (size.h * 0.5)), size,
				[DRAW_ITEM_FLAGS.NameBg, DRAW_ITEM_FLAGS.NameShort,
				DRAW_ITEM_FLAGS.AltTextBg, DRAW_ITEM_FLAGS.AltText]
			);
		}
		
		if (isHovered)
		{
			// DRAW DRAG ITEM INDICATOR
			if (!is_undefined(global.ObjMouse.dragItem))
			{
				var dragItemData = global.ObjMouse.dragItem.item_data;
				var gridAreaColor = inventory.IsItemWhiteListed(dragItemData) ? #0fb80f : #b80f0f;
				
				if (!is_undefined(itemData))
				{
					if (CombineItems(dragItemData, itemData, true))
					{
						gridAreaColor = #ffe100;
					}
				}
				
				draw_sprite_ext(
					sprGUIBg, 0,
					position.X, position.Y,
					size.w, size.h,
					0, gridAreaColor, 0.5
				);
			}
		}
	}
}