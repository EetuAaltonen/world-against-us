function WindowInventoryGrid(_elementId, _position, _size, _backgroundColor, _inventory) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	inventory = _inventory;
	
	initGrid = true;
	
	gridCellSize = new Size(0, 0);
	gridSprite = sprGUIGrid;
	gridSpriteScale = 1;
	
	itemBackgroundSprite = sprGUIItemBg;
	
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
	
	static UpdateMouseHoverIndex = function()
	{
		mouseHoverIndex = undefined;
		
		var mouseX = device_mouse_x_to_gui(0);
		var mouseY = device_mouse_y_to_gui(0);
		
		if (point_in_rectangle(mouseX, mouseY, position.X, position.Y, position.X + size.w, position.Y + size.h))
		{
			var indexX = floor((mouseX - position.X) / gridCellSize.w);
			var indexY = floor((mouseY - position.Y) / gridCellSize.h);
			mouseHoverIndex = new GridIndex(
				// MAKE SURE THAT MOUSE HOVER INDEX IS INSIDE INVENTORY INDEXES
				min((inventory.size.columns - 1), indexX),
				min((inventory.size.rows - 1), indexY)
			);
		}
	}
	
	static DrawContent = function()
	{
		if (initGrid)
		{
			initGrid = false;
			
			var newGridSize = (size.w / inventory.grid.columns);
			gridCellSize = new Size(newGridSize, newGridSize);
			gridSpriteScale = gridCellSize.w / sprite_get_width(gridSprite);
			
			size = new Size(size.w, (gridCellSize.h * inventory.size.rows));
		} else {
			// DRAW GRID BACKGROUND
			var xPos = position.X;
			var yPos = position.Y;
		
			for (var i = 0; i < inventory.grid.rows; i++)
			{
				for (var j = 0; j < inventory.grid.columns; j++)
				{
					var gridSpriteIndex = 0;
				
					draw_sprite_ext(gridSprite, gridSpriteIndex, xPos, yPos, gridSpriteScale, gridSpriteScale, 0, c_white, 1);
					xPos += gridCellSize.w;
				}
				yPos += gridCellSize.h;
				xPos = position.X;
			}
			
			// DRAW ITEMS
			var itemCount = inventory.GetItemCount();
			for (var i = 0; i < itemCount; i++)
			{
				var item = inventory.GetItem(i);
				xPos = position.X + (gridCellSize.w * item.grid_index.col);
				yPos = position.Y + (gridCellSize.h * item.grid_index.row);
				
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
					var iconScale = CalculateItemIconScale(item.icon, item.size, item.rotated, gridCellSize);
					var iconRotation = CalculateItemIconRotation(item.rotated);
				
					// DRAW BACKGROUND
					var gridSpriteIndex = 0;
					if (!item.known) {
						gridSpriteIndex = 2;
					} else if ((!is_undefined(mouseHoverIndex) && is_undefined(global.DragItem)))
					{
						if (point_in_rectangle(mouseHoverIndex.col, mouseHoverIndex.row, item.grid_index.col, item.grid_index.row, (item.grid_index.col + (item.size.w - 1)), (item.grid_index.row + (item.size.h - 1))))
						{
							gridSpriteIndex = 1;
						}
					}
					draw_sprite_ext(itemBackgroundSprite, gridSpriteIndex, xPos, yPos, item.size.w * gridSpriteScale, item.size.h * gridSpriteScale, 0, c_white, 1);
				
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
						xPos + ((gridCellSize.w * 0.5) * item.size.w),
						yPos + ((gridCellSize.h * 0.5) * item.size.h),
						iconScale, iconScale, iconRotation, c_white, 1
					);
					shader_reset();
				
					// ITEM QUANTITY
					DrawItemQuantity(item.quantity, xPos, yPos, gridCellSize);
				}
			}
			
			// MOUSE DEBUG INFO
			if (!is_undefined(mouseHoverIndex))
			{
				var mouseX = device_mouse_x_to_gui(0);
				var mouseY = device_mouse_y_to_gui(0);
				draw_text(mouseX + 5, mouseY + 20, string(inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
			}
			
			// DRAW DRAGGED ITEM
			DrawDraggedItem();
		}
	}
	
	static DrawDraggedItem = function()
	{
		if (!is_undefined(global.DragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var xHoverPos = position.X + (gridCellSize.w * mouseHoverIndex.col);
				var yHoverPos = position.Y + (gridCellSize.h * mouseHoverIndex.row);
				
				// DRAW BACKGROUND
				var backgroundIndex = (inventory.IsGridAreaEmpty(mouseHoverIndex.col, mouseHoverIndex.row, global.DragItem, global.DragItem.source_type, global.DragItem.grid_index)) ? 0 : 3;
				draw_sprite_ext(sprGUIItemBg, backgroundIndex, xHoverPos, yHoverPos, global.DragItem.size.w * gridSpriteScale, global.DragItem.size.h * gridSpriteScale, 0, c_white, 0.4);
				
				// DRAW ITEM
				var iconScale = CalculateItemIconScale(global.DragItem.icon, global.DragItem.size, global.DragItem.rotated, gridCellSize);
				var iconRotation = CalculateItemIconRotation(global.DragItem.rotated);
				draw_sprite_ext(
					global.DragItem.icon, 0,
					xHoverPos + ((inventory.grid.size.w * 0.5) * global.DragItem.size.w * gridSpriteScale),
					yHoverPos + ((inventory.grid.size.h * 0.5) * global.DragItem.size.h * gridSpriteScale),
					iconScale, iconScale, iconRotation, c_white, 0.4
				);
				
				// ITEM QUANTITY
				DrawItemQuantity(global.DragItem.quantity, xHoverPos, yHoverPos, inventory.grid.size);
			}
		}
	}
	
	static DrawItemQuantity = function(_itemQuantity, _guiXPos, _guiYPos, _gridCellSize)
	{
		if (_itemQuantity > 1)
		{
			draw_set_font(font_small_bold);
			draw_text(
				_guiXPos + 5,
				_guiXPos + _gridCellSize.h - 15,
				string(_itemQuantity)
			);
			draw_set_font(font_default);
		}
	}
	
	static CalculateItemIconScale = function(_itemIcon, _itemSize, _itemRotated, _gridCellSize)
	{
		// CALCULATE ICON SIZE
		var padding = 0.85;
		var iconScale = 1;
		if (_itemRotated)
		{
			iconScale = ScaleSpriteToFitSize(
				_itemIcon,
				(_gridCellSize.w * padding) * _itemSize.h,
				(_gridCellSize.h * padding) * _itemSize.w
			);
		} else {
			iconScale = ScaleSpriteToFitSize(
				_itemIcon,
				(_gridCellSize.w * padding) * _itemSize.w,
				(_gridCellSize.h * padding) * _itemSize.h
			);
		}
		
		return iconScale;
	}
	
	static CalculateItemIconRotation = function(_itemRotated)
	{
		return _itemRotated ? 90 : 0;
	}
}