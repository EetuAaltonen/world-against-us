function Inventory(_inventoryId, _type, _size = { columns: 10, rows: 10 }) constructor
{
	inventoryId = _inventoryId
    items = ds_list_create();
	size = _size;
	type = _type;
	
	gridData = [];
	// Init grid data
    for (var i = 0; i < size.rows; i++) {
	  for (var j = 0; j < size.columns; j ++) {
	    gridData[i, j] = noone;
	  }
	}
	
	grid = {
		columns: size.columns,
		rows: size.rows,
		size: {
			w: 48,
			h: 48,
		}
	};
	
	showInventory = false;
	
	// Item search
	identifyIndex = undefined;
	identifyDuration = TimerFromSeconds(2);
	identifyTimer = 0;
	
	// Hover effect
	mouseHoverIndex = noone;
	
	static GetItemCount = function()
    {
		return ds_list_size(items);
    }

    static AddItem = function(_item, _grid_index = noone, _known = true, _ignore_network = false)
    {
		var addedItem = noone;
        _item.grid_index = (_grid_index != noone) ? new GridIndex(_grid_index.col, _grid_index.row) : FindEmptyIndex(_item);
		_item.known = _known;
		
		if (_item.grid_index != noone)
		{
			_item.source_type = type;
			FillGridArea(_item.grid_index.col, _item.grid_index.row, _item.size, new GridIndex(_item.grid_index.col, _item.grid_index.row));
			addedItem = _item.Clone();
			
			if (!_ignore_network)
			{
				if (type == INVENTORY_TYPE.LootContainer)
				{
					// NETWORKING CONTAINER DELETE ITEM
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_ADD_ITEM);
					var jsonData = json_stringify(_item);
				
					buffer_write(networkBuffer, buffer_text , inventoryId);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
			}
			
			ds_list_add(items, addedItem);
		} else {
			// MESSAGE LOG
			AddMessageLog("Item: '" + string(_item.name) + "' doesn't fit!");
		}
		
		return addedItem;
    }
	
	static GetItem = function(_index)
    {
		return ds_list_find_value(items, _index);
    }
	
	static GetItemByGridIndex = function(_gridIndex)
    {
		var foundItem = noone;
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItem(i);
			if (item.grid_index.col == _gridIndex.col &&
				item.grid_index.row == _gridIndex.row)
			{
				foundItem = item;
				break;
			}
		}
		return foundItem;
    }
	
	static MoveAndRotateItemByGridIndex = function(_gridIndex, _newGridIndex, _isRotated)
	{
		var item = GetItemByGridIndex(_gridIndex);
		var originalRotation = item.rotated;
		
		if (item != noone)
		{
			// Clear previous spot
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, noone);
			
			// Set rotation
			if (_isRotated != item.rotated)
			{
				item.Rotate();
			}
		
			if (IsGridAreaEmpty(item.grid_index.col, item.grid_index.row, item, item.source_type, item.grid_index))
			{
				if (type == INVENTORY_TYPE.LootContainer)
				{
					// NETWORKING CONTAINER DELETE ITEM
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_MOVE_AND_ROTATE_ITEM);
					var jsonData = json_stringify(item);
					show_debug_message(string(item.rotated));
				
					buffer_write(networkBuffer, buffer_text , inventoryId);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.col);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.row);
					buffer_write(networkBuffer, buffer_bool, item.rotated);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
				
				item.grid_index = _newGridIndex;
			} else {
				// Reverse rotation if item doesn't fit
		        if (item.rotated != originalRotation) {
		          item.Rotate();
		        }
			}
			
			// Set new spot
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, item.grid_index.Clone());
		}
	}
	
	static RemoveItem = function(_index)
    {
		var item = GetItem(_index);
		if (type == INVENTORY_TYPE.LootContainer)
		{
			// NETWORKING CONTAINER DELETE ITEM
			var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_DELETE_ITEM);
			var jsonData = json_stringify(item);
			
			buffer_write(networkBuffer, buffer_text , inventoryId);
			buffer_write(networkBuffer, buffer_text, jsonData);
			global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
		}
		
		FillGridArea(item.grid_index.col, item.grid_index.row, item.size, noone);
		ds_list_delete(items, _index);
    }
	
	static RemoveItemByGridIndex = function(_gridIndex)
    {
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItem(i);
			if (item.grid_index.col == _gridIndex.col &&
				item.grid_index.row == _gridIndex.row)
			{
				RemoveItem(i);
				break;
			}
		}
    }
	
	static FindEmptyIndex = function(_item)
	{
		var index = noone;
		for (var i = 0; i < size.rows; i++)
		{
			if (index != noone) break;
			for (var j = 0; j < size.columns; j++)
			{
				if (index != noone) break;
				if (gridData[i][j] == noone)
				{
					if (IsGridAreaEmpty(j, i, _item))
					{
						index = new GridIndex(j, i);
					} else {
						// CHECK ROTATED VERSION
						_item.Rotate();
						if (IsGridAreaEmpty(j, i, _item))
						{
							index = new GridIndex(j, i);
						} else {
							// REVERSE ROTATION IF DIDN'T FIT
							_item.Rotate();
						}
					}
				}
			}
		}
		return index;
	}
	
	static IsGridAreaEmpty = function(_col, _row, _item, _ignoreSource, _ignoreGridIndex)
	{
		var isEmpty = true;
		if ((_col + _item.size.w - 1) < array_length(gridData[0]) &&
			(_row + _item.size.h - 1) < array_length(gridData))
		{
			for (var i = _row; i < (_row + _item.size.h); i++)
			{
				if (!isEmpty) break;
				for (var j = _col; j < (_col + _item.size.w); j++)
				{
					if (!isEmpty) break;
					var gridIndex = gridData[i][j];
					isEmpty = (gridIndex == noone || (_item.source_type == _ignoreSource && (gridIndex.col == _ignoreGridIndex.col && gridIndex.row == _ignoreGridIndex.row)));
				}
			}
		} else {
			isEmpty = false;
		}
		return isEmpty;
	}
	
	static FillGridArea = function(_col, _row, _itemSize, _value)
	{
		for (var i = _row; i < (_row + _itemSize.h); i++)
		{
			for (var j = _col; j < (_col + _itemSize.w); j++)
			{
				gridData[i][j] = _value;
			}
		}
	}
	
	static DrawGUI = function(_guiXPos, _guiYPos)
	{
		if (is_undefined(identifyIndex))
		{
			InventoryInteractions();
		} else {
			InventoryIdentify();
		}
		
		var xPos = _guiXPos;
		var yPos = _guiYPos;
		for (var i = 0; i < grid.rows; i++)
		{
			for (var j = 0; j < grid.columns; j++)
			{
				// DRAW GRID BACKGROUND
				var gridSpriteIndex = 0;
				if (mouseHoverIndex != noone)
				{
					if ((mouseHoverIndex.col == j && mouseHoverIndex.row == i))
					{
						gridSpriteIndex = 1;
					}
				}
				draw_sprite_ext(sprGUIGrid, gridSpriteIndex, xPos, yPos, 1, 1, 0, c_white, 1);
				// DEBUG INFO
				/*
				draw_set_color(c_red);
				var text = (gridData[i][j] != noone) ? 1 : 0;
				draw_text(xPos + 10, yPos + 10, text);
				draw_set_color(c_black);
				*/
				
				xPos += grid.size.w;
			}
			yPos += grid.size.h;
			xPos = _guiXPos;
		}
	
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount + 1; i++)
		{
			// DO EXTRA LOOP TO DRAW DRAGGED ITEM
			var drawDragItem = (i >= itemCount);
			var item = noone;
			
			if (drawDragItem)
			{
				if (global.DragItem == noone || mouseHoverIndex == noone) break;
				if (!IsGridAreaEmpty(mouseHoverIndex.col, mouseHoverIndex.row, global.DragItem, global.DragItem.source_type, global.DragItem.grid_index)) break;
				
				var item = global.DragItem.Clone();
				item.grid_index = mouseHoverIndex.Clone();
			} else {
				item = GetItem(i);
			}
			
			xPos = _guiXPos + (grid.size.w * item.grid_index.col);
			yPos = _guiYPos + (grid.size.h * item.grid_index.row);
			
			var itemDragged = false;
			if (global.DragItem != noone)
			{
				if (global.DragItem.source_type == item.source_type)
				{
					if (item.grid_index.col == global.DragItem.grid_index.col && item.grid_index.row == global.DragItem.grid_index.row)
					{
						itemDragged = true;
					}
				}
			}
			
			// DRAW ITEM BACKGROUND
			if (!itemDragged)
			{
				var gridSpriteIndex = 0;
				if (!item.known) {
					gridSpriteIndex = 2;
				} else if ((mouseHoverIndex != noone && global.DragItem == noone) || drawDragItem)
				{
					if ((mouseHoverIndex.col >= item.grid_index.col && mouseHoverIndex.col <= (item.grid_index.col + item.size.w - 1) &&
						mouseHoverIndex.row >= item.grid_index.row && mouseHoverIndex.row <= (item.grid_index.row + item.size.h - 1)) || drawDragItem)
					{
						gridSpriteIndex = 1;
					}
				}
				
				draw_sprite_ext(sprGUIItemBg, gridSpriteIndex, xPos, yPos, item.size.w, item.size.h, 0, c_white, 1);
			}
			
			// CALCULATE ICON SIZE
			var padding = 0.85;
			var iconAlpha = itemDragged ? 0.4 : 1;
			var iconRotation = item.rotated ? 90 : 0;
			var iconScale = 1;
			if (item.rotated)
			{
				iconScale = ScaleSpriteToFitSize(
					item.icon,
					(grid.size.w * padding) * item.size.h,
					(grid.size.h * padding) * item.size.w
				);
			} else {
				iconScale = ScaleSpriteToFitSize(
					item.icon,
					(grid.size.w * padding) * item.size.w,
					(grid.size.h * padding) * item.size.h
				);
			}
			
			// DRAW ITEM
			if (item.known)
			{
				draw_sprite_ext(
					item.icon, 0,
					xPos + ((grid.size.w * 0.5) * item.size.w),
					yPos + ((grid.size.h * 0.5) * item.size.h),
					iconScale, iconScale, iconRotation, c_white, iconAlpha
				);
			} else {
				if (item.grid_index == identifyIndex)
				{
					shader_set(shdrIdentifySprite);
				} else {
					shader_set(shdrFogSprite);	
				}
				
				draw_sprite_ext(
					item.icon, 0,
					xPos + ((grid.size.w * 0.5) * item.size.w),
					yPos + ((grid.size.h * 0.5) * item.size.h),
					iconScale, iconScale, iconRotation, c_white, iconAlpha
				);
				shader_reset();	
			}
			
			// ITEM QUANTITY
			if (item.quantity > 1)
			{
				draw_set_font(font_small_bold);
				draw_text(
					xPos + 5,
					yPos + grid.size.h - 15,
					string(item.quantity)
				);
				draw_set_font(font_default);
			}
		}
		
		// UPDATE MOUSE HOVER INDEX
		mouseHoverIndex = GetMouseHoverIndex(_guiXPos, _guiYPos, grid);
		// MOUSE DEBUG INFO
		if (mouseHoverIndex != noone)
		{
			var mouseX = window_mouse_get_x();
			var mouseY = window_mouse_get_y();
			draw_text(mouseX, mouseY + 100, string(gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
		}
	}
	
	static GetMouseHoverIndex = function(_guiXPos, _guiYPos, grid)
	{
		var mouseX = window_mouse_get_x();
		var mouseY = window_mouse_get_y();
		var mouseHoverIndex = noone;
		var gridWidth = grid.size.w * grid.columns;
		var gridHeight = grid.size.h * grid.rows;
		
		if (mouseX > _guiXPos && mouseX < _guiXPos + gridWidth &&
			mouseY > _guiYPos && mouseY < _guiYPos + gridHeight)
		{
			var indexX = floor((mouseX - _guiXPos) / grid.size.w);
			var indexY = floor((mouseY - _guiYPos) / grid.size.h);
			mouseHoverIndex = new GridIndex(indexX, indexY);
		}
		
		return mouseHoverIndex;
	}
	
	static InventoryIdentify = function()
	{
		if (!is_undefined(identifyIndex))
		{
			if (identifyTimer-- <= 0)
			{
				var item = GetItemByGridIndex(identifyIndex);
				item.known = true;
				
				if (type == INVENTORY_TYPE.LootContainer)
				{
					// NETWORKING CONTAINER DELETE ITEM
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_IDENTIFY_ITEM);
					var jsonData = json_stringify(item);
			
					buffer_write(networkBuffer, buffer_text , inventoryId);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
				
				// RESET INDENTIFY TARGET AND TIMER
				identifyIndex = undefined;
				identifyTimer = 0;
			}
		}
	}
	
	static InventoryInteractions = function()
	{
		if (mouseHoverIndex	!= noone)
		{
			// ROTATE
			if (keyboard_check_released(ord("R")))
			{
				if (global.DragItem != noone)
				{
					global.DragItem.Rotate();
				} else {
					var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
					if (itemGridIndex != noone)
					{
						var isItemRotated = GetItemByGridIndex(itemGridIndex).rotated;
						MoveAndRotateItemByGridIndex(itemGridIndex, itemGridIndex, !isItemRotated);
					}
				}
			}
			// DRAG -N- DROP
			else if (!keyboard_check(vk_anykey))
			{
				if (mouse_check_button_pressed(mb_left))
				{
					var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
					if (itemGridIndex != noone)
					{
						var item = GetItemByGridIndex(itemGridIndex);
						global.DragItem = item.Clone();
					}	
				} else if (mouse_check_button_released(mb_left))
				{
					if (global.DragItem != noone)
					{
						var newGridIndex = mouseHoverIndex.Clone();
						if (IsGridAreaEmpty(newGridIndex.col, newGridIndex.row, global.DragItem, global.DragItem.source_type, global.DragItem.grid_index))
						{
							var inventorySource = (global.DragItem.source_type == INVENTORY_TYPE.PlayerBackpack) ? global.PlayerBackpack : global.ObjTempInventory.inventory;
							if (inventorySource != noone)
							{
								if (type == global.DragItem.source_type)
								{
									with (inventorySource)
									{
										MoveAndRotateItemByGridIndex(global.DragItem.grid_index, newGridIndex, global.DragItem.rotated);
									}
								} else {
									var newItem = AddItem(global.DragItem.Clone(), newGridIndex, global.DragItem.known);
									if (newItem != noone)
									{
										with (inventorySource)
										{
											var oldItem = GetItemByGridIndex(global.DragItem.grid_index);
											RemoveItemByGridIndex(oldItem.grid_index);
										}
									} else {
										// MESSAGE LOG
										AddMessageLog(string(global.DragItem.name) + " transfer failed!");	
									}
								}
							}
						}
						global.DragItem = noone;
					}
				} else if (mouse_check_button_released(mb_middle))
				{
					var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
					if (itemGridIndex != noone)
					{
						var item = GetItemByGridIndex(itemGridIndex);
						if (item != noone)
						{
							identifyIndex = item.grid_index;
							identifyTimer = identifyDuration;
						}
					}
				} else if (mouse_check_button_released(mb_right))
				{
					if (type == INVENTORY_TYPE.PlayerBackpack)
					{
						if (global.ObjWeapon != noone)
						{
							var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							if (itemGridIndex != noone)
							{
								var item = GetItemByGridIndex(itemGridIndex);
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
				var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
				if (itemGridIndex != noone)
				{
					var item = GetItemByGridIndex(itemGridIndex);
					if (item != noone)
					{						
						if (type == INVENTORY_TYPE.PlayerBackpack)
						{
							if (global.ObjTempInventory != noone)
							{
								if (global.ObjTempInventory.inventory != noone)
								{
									with (global.ObjTempInventory.inventory)
									{
										if (AddItem(item.Clone(), noone, item.known) != noone)
										{
											other.RemoveItemByGridIndex(itemGridIndex);	
										}
									}
								}
							}
						} else {
							if (global.PlayerBackpack != noone)
							{
								with (global.PlayerBackpack)
								{
									if (AddItem(item.Clone(), noone, item.known) != noone)
									{
										other.RemoveItemByGridIndex(itemGridIndex);
									}
								}
							}
						}	
					}
				}
			} else if (keyboard_check(vk_shift) && mouse_check_button_released(mb_right))
			{
				// TODO: Write item drop function
				//var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
				//RemoveItemByGridIndex(itemGridIndex);
			}
		}
	}
}
