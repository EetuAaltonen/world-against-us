function InventoryWindow(_windowId, _type, _guiPos, _size, _zIndex, _inventory = undefined) : GameWindow(_windowId, _type, _guiPos, _size, _zIndex) constructor
{
	inventory = _inventory;
	gridPos = new Vector2(_guiPos.X + 10, _guiPos.Y + 10);
	mouseHoverIndex = undefined;
	
	static UpdateContent = function()
	{
		if (!is_undefined(inventory.identifyIndex))
		{
			inventory.InventoryIdentify();
		}
		
		// UPDATE MOUSE HOVER INDEX
		UpdateMouseHoverIndex();
	}
	
	static OnFocusLost = function()
	{
		CheckContentInteraction();
	}
	
	static UpdateMouseHoverIndex = function()
	{
		mouseHoverIndex = undefined;
		
		var mouseX = window_mouse_get_x();
		var mouseY = window_mouse_get_y();
		var gridWidth = inventory.grid.size.w * inventory.grid.columns;
		var gridHeight = inventory.grid.size.h * inventory.grid.rows;
		
		if (mouseX > gridPos.X && mouseX < gridPos.X + gridWidth &&
			mouseY > gridPos.Y && mouseY < gridPos.Y + gridHeight)
		{
			var indexX = floor((mouseX - gridPos.X) / inventory.grid.size.w);
			var indexY = floor((mouseY - gridPos.Y) / inventory.grid.size.h);
			mouseHoverIndex = new GridIndex(indexX, indexY);
		}
	}
	
	static CheckContentInteraction = function()
	{
		// CHECK FOR INTERACTIONS
		if (!is_undefined(mouseHoverIndex))
		{
			if (is_undefined(inventory.identifyIndex))
			{
				// ROTATE
				if (keyboard_check_released(ord("R")))
				{
					if (!is_undefined(global.DragItem))
					{
						global.DragItem.Rotate();
					} else {
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (itemGridIndex != noone)
						{
							var isItemRotated = inventory.GetItemByGridIndex(itemGridIndex).rotated;
							inventory.MoveAndRotateItemByGridIndex(itemGridIndex, itemGridIndex, !isItemRotated);
						}
					}
				}
			
				// DRAG -N- DROP
				else if (!keyboard_check(vk_anykey))
				{
					if (mouse_check_button_pressed(mb_left))
					{
						if (is_undefined(global.DragItem))
						{
							var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							if (itemGridIndex != noone)
							{
								var item = inventory.GetItemByGridIndex(itemGridIndex);
								if (item.known)
								{
									global.DragItem = item.Clone();
								}
							}
						}
					}  else if (mouse_check_button_released(mb_left))
					{
						if (!is_undefined(global.DragItem))
						{
							var dropGridIndex = mouseHoverIndex.Clone();
							if (inventory.IsGridAreaEmpty(dropGridIndex.col, dropGridIndex.row, global.DragItem, global.DragItem.source_type, global.DragItem.grid_index))
							{
								var inventorySource = (global.DragItem.source_type == INVENTORY_TYPE.PlayerBackpack) ? global.PlayerBackpack : global.ObjTempInventory.inventory;
								if (inventorySource != noone)
								{
									if (inventory.type == global.DragItem.source_type)
									{
										inventory.MoveAndRotateItemByGridIndex(global.DragItem.grid_index, dropGridIndex, global.DragItem.rotated);
									} else {
										if (inventory.AddItem(global.DragItem.Clone(), dropGridIndex, global.DragItem.known))
										{
											var oldItem = inventorySource.GetItemByGridIndex(global.DragItem.grid_index);
											inventorySource.RemoveItemByGridIndex(oldItem.grid_index);
										} else {
											// MESSAGE LOG
											AddMessageLog(string(global.DragItem.name) + " transfer failed!");	
										}
									}
								}
							}
							global.DragItem = undefined;
						}
					}
					// IDENTIFY ITEM
					else if (mouse_check_button_released(mb_middle))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (itemGridIndex != noone)
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (item != noone)
							{
								inventory.identifyIndex = item.grid_index;
								inventory.identifyTimer = inventory.identifyDuration;
							}
						}
					}
					// EQUIP WEAPON
					else if (mouse_check_button_released(mb_right))
					{
						if (inventory.type == INVENTORY_TYPE.PlayerBackpack)
						{
							if (global.ObjWeapon != noone)
							{
								var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
								if (itemGridIndex != noone)
								{
									var item = inventory.GetItemByGridIndex(itemGridIndex);
									if (item != noone)
									{
										if (item.type == "Primary_Weapon")
										{
											global.ObjWeapon.primaryWeapon = item;
											global.ObjWeapon.initWeapon = true;
										}
									}
								}
							}
						}
					}
				}
				// QUICK TRANSFER
				else if (keyboard_check(vk_control) && mouse_check_button_released(mb_left))
				{
					var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
					if (itemGridIndex != noone)
					{
						var item = inventory.GetItemByGridIndex(itemGridIndex);
						if (item != noone)
						{						
							if (inventory.type == INVENTORY_TYPE.PlayerBackpack)
							{
								if (global.ObjTempInventory != noone)
								{
									var targetInventory = global.ObjTempInventory.inventory;
									if (targetInventory != noone)
									{
										if (targetInventory.AddItem(item.Clone(), noone, item.known) != noone)
										{
											inventory.RemoveItemByGridIndex(itemGridIndex);	
										}
									}
								}
							} else {
								if (global.PlayerBackpack != noone)
								{
									if (global.PlayerBackpack.AddItem(item.Clone(), noone, item.known) != noone)
									{
										inventory.RemoveItemByGridIndex(itemGridIndex);
									}
								}
							}	
						}
					}
				}
			}
		} else {
			// RESET DRAGGED ITEM IF DROPPED OUT OF GRID
			if (mouse_check_button_released(mb_left))
			{
				if (!is_undefined(global.DragItem))
				{
					if (inventory.type == global.DragItem.source_type)
					{
						global.DragItem = undefined;	
					}
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		var xPos = gridPos.X;
		var yPos = gridPos.Y;
			
		// DRAW GRID BACKGROUND
		for (var i = 0; i < inventory.grid.rows; i++)
		{
			for (var j = 0; j < inventory.grid.columns; j++)
			{
				// DRAW GRID BACKGROUND
				var gridSpriteIndex = 0;
				if (inventory.gridData[i, j] != noone)
				{
					gridSpriteIndex = 2;
				} else if (!is_undefined(mouseHoverIndex))
				{
					if ((mouseHoverIndex.col == j && mouseHoverIndex.row == i))
					{
						gridSpriteIndex = 1;
					}
				}
				draw_sprite_ext(sprGUIGrid, gridSpriteIndex, xPos, yPos, 1, 1, 0, c_white, 1);
				xPos += inventory.grid.size.w;
			}
			yPos += inventory.grid.size.h;
			xPos = gridPos.X;
		}

		// DRAW ITEMS
		var itemCount = inventory.GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = inventory.GetItem(i);
			xPos = gridPos.X + (inventory.grid.size.w * item.grid_index.col);
			yPos = gridPos.Y + (inventory.grid.size.h * item.grid_index.row);
				
			// CHECK IF ITEM IS DRAGGED
			var itemDragged = false;
			if (!is_undefined(global.DragItem))
			{
				if (global.DragItem.source_type == item.source_type)
				{
					itemDragged = (item.grid_index.col == global.DragItem.grid_index.col && item.grid_index.row == global.DragItem.grid_index.row)
				}
			}
				
			// SKIP DRAWING IF ITEM IS DRAGGED
			if (!itemDragged)
			{
				var iconScale = CalculateItemIconScale(item.icon, item.size, item.rotated, inventory.grid.size);
				var iconRotation = CalculateItemIconRotation(item.rotated);
				
				// DRAW BACKGROUND
				var gridSpriteIndex = 0;
				if (!item.known) {
					gridSpriteIndex = 2;
				} else if ((!is_undefined(mouseHoverIndex) && is_undefined(global.DragItem)))
				{
					if ((mouseHoverIndex.col >= item.grid_index.col && mouseHoverIndex.col < (item.grid_index.col + item.size.w) &&
						mouseHoverIndex.row >= item.grid_index.row && mouseHoverIndex.row < (item.grid_index.row + item.size.h)))
					{
						gridSpriteIndex = 1;
					}
				}
				draw_sprite_ext(sprGUIItemBg, gridSpriteIndex, xPos, yPos, item.size.w, item.size.h, 0, c_white, 1);
				
				// DRAW ITEM
				if (!item.known)
				{
					shader_set(shdrFogSprite);
					if (!is_undefined(inventory.identifyIndex))
					{
						if (item.grid_index == inventory.identifyIndex)
						{
							shader_reset();
							shader_set(shdrIdentifySprite);
						}
					}
				}
				
				draw_sprite_ext(
					item.icon, 0,
					xPos + ((inventory.grid.size.w * 0.5) * item.size.w),
					yPos + ((inventory.grid.size.h * 0.5) * item.size.h),
					iconScale, iconScale, iconRotation, c_white, 1
				);
				shader_reset();
				
				// ITEM QUANTITY
				DrawItemQuantity(item.quantity, xPos, yPos, inventory.grid.size);
			}
		}
		
		// MOUSE DEBUG INFO
		if (!is_undefined(mouseHoverIndex))
		{
			var mouseX = window_mouse_get_x();
			var mouseY = window_mouse_get_y();
			draw_text(mouseX, mouseY + 100, string(inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
		}
		
		// DRAW DRAGGED ITEM
		DrawDraggedItem();
	}
	
	static DrawDraggedItem = function()
	{
		if (!is_undefined(global.DragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var xHoverPos = gridPos.X + (inventory.grid.size.w * mouseHoverIndex.col);
				var yHoverPos = gridPos.Y + (inventory.grid.size.h * mouseHoverIndex.row);
				
				// DRAW BACKGROUND
				var backgroundIndex = (inventory.IsGridAreaEmpty(mouseHoverIndex.col, mouseHoverIndex.row, global.DragItem, global.DragItem.source_type, global.DragItem.grid_index)) ? 0 : 3;
				draw_sprite_ext(sprGUIItemBg, backgroundIndex, xHoverPos, yHoverPos, global.DragItem.size.w, global.DragItem.size.h, 0, c_white, 0.4);
				
				// DRAW ITEM
				var iconScale = CalculateItemIconScale(global.DragItem.icon, global.DragItem.size, global.DragItem.rotated, inventory.grid.size);
				var iconRotation = CalculateItemIconRotation(global.DragItem.rotated);
				draw_sprite_ext(
					global.DragItem.icon, 0,
					xHoverPos + ((inventory.grid.size.w * 0.5) * global.DragItem.size.w),
					yHoverPos + ((inventory.grid.size.h * 0.5) * global.DragItem.size.h),
					iconScale, iconScale, iconRotation, c_white, 0.4
				);
				
				// ITEM QUANTITY
				DrawItemQuantity(global.DragItem.quantity, xHoverPos, yHoverPos, inventory.grid.size);
			}
		}
	}
	
	static DrawItemQuantity = function(_itemQuantity, _guiXPos, _guiYPos, _gridSize)
	{
		if (_itemQuantity > 1)
		{
			draw_set_font(font_small_bold);
			draw_text(
				_guiXPos + 5,
				_guiXPos + _gridSize.h - 15,
				string(_itemQuantity)
			);
			draw_set_font(font_default);
		}
	}
	
	static CalculateItemIconScale = function(_itemIcon, _itemSize, _itemRotated, _gridSize)
	{
		// CALCULATE ICON SIZE
		var padding = 0.85;
		var iconScale = 1;
		if (_itemRotated)
		{
			iconScale = ScaleSpriteToFitSize(
				_itemIcon,
				(_gridSize.w * padding) * _itemSize.h,
				(_gridSize.h * padding) * _itemSize.w
			);
		} else {
			iconScale = ScaleSpriteToFitSize(
				_itemIcon,
				(_gridSize.w * padding) * _itemSize.w,
				(_gridSize.h * padding) * _itemSize.h
			);
		}
		
		return iconScale;
	}
	
	static CalculateItemIconRotation = function(_itemRotated)
	{
		return _itemRotated ? 90 : 0;
	}
}