function Inventory(_type, _size = { columns: 10, rows: 10 }) constructor
{
    items = ds_list_create();
	size = _size;
	type = _type;
	
	// Init grid data
	gridData = [];
    for(var i = 0; i < size.rows; i++){
	  for(var j = 0; j < size.columns; j ++){
	    gridData[i, j] = noone;
	  }
	}
	
	grid = {
		columns: size.columns,
		rows: size.rows,
		size: {
			w: 48,//82,
			h: 48,//82
		},
		outline: 2
	};
	
	showInventory = false;
	
	// Item search
	searchIndex = noone;
	searchDuration = TimerFromSeconds(2);
	searchTimer = 0;
	
	// Hover effect
	mouseHoverIndex = noone;
	
	static GetItemCount = function()
    {
		return ds_list_size(items);
    }

    static AddItem = function(_item, _gridIndex = noone, _known = true)
    {
		var addedItem = noone;
        _item.gridIndex = (_gridIndex != noone) ? _gridIndex : FindEmptyIndex(_item);
		_item.known = _known;
		
		if (_item.gridIndex != noone)
		{
			_item.sourceType = type;
			FillGridArea(_item.gridIndex.col, _item.gridIndex.row, _item.size, _item.gridIndex.Clone());
			addedItem = _item.Clone();
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
			if (item.gridIndex.col == _gridIndex.col &&
				item.gridIndex.row == _gridIndex.row)
			{
				foundItem = item;
				break;
			}
		}
		return foundItem;
    }
	
	static RemoveItem = function(_index)
    {
		var item = GetItem(_index);
		FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, noone);
		ds_list_delete(items, _index);
    }
	
	static RemoveItemByGridIndex = function(_gridIndex)
    {
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItem(i);
			if (item.gridIndex.col == _gridIndex.col &&
				item.gridIndex.row == _gridIndex.row)
			{
				FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, noone);
				ds_list_delete(items, i);
				break;
			}
		}
    }
	
	static FindEmptyIndex = function(_item, _itemRotation = 1)
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
					isEmpty = (gridIndex == noone || (_item.sourceType == _ignoreSource && (gridIndex.col == _ignoreGridIndex.col && gridIndex.row == _ignoreGridIndex.row)));
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
		if (searchIndex == noone)
		{
			InventoryInteractions();
		} else {
			InventorySearch();	
		}
		
		var xPos = _guiXPos;
		var yPos = _guiYPos;
		for (var i = 0; i < grid.rows; i++)
		{
			for (var j = 0; j < grid.columns; j++)
			{
				var frameColor = make_colour_rgb(110, 110, 110);
				draw_rectangle_color(
					xPos, yPos,
					xPos + grid.size.w,
					yPos + grid.size.h,
					frameColor, frameColor, frameColor, frameColor, false
				);
				
				var gridColor = make_colour_rgb(144, 144, 144);
				if (mouseHoverIndex != noone)
				{
					if ((global.DragItem != noone) && (mouseHoverIndex.col == j && mouseHoverIndex.row == i))
					{
						gridColor = make_colour_rgb(100, 100, 100);
					}
				}
				draw_rectangle_color(
					xPos + grid.outline,
					yPos + grid.outline,
					xPos + grid.size.w - grid.outline,
					yPos + grid.size.h - grid.outline,
					gridColor, gridColor, gridColor, gridColor, false
				);
				
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
			var drawDragItem = (i >= itemCount);
			var item = noone;
			
			if (drawDragItem)
			{
				if (global.DragItem == noone || mouseHoverIndex == noone) break;
				if (!IsGridAreaEmpty(mouseHoverIndex.col, mouseHoverIndex.row, global.DragItem, global.DragItem.sourceType, global.DragItem.gridIndex)) break;
				
				var item = global.DragItem.Clone();
				item.gridIndex = mouseHoverIndex.Clone();
			} else {
				item = GetItem(i);
			}
			
			xPos = _guiXPos + (grid.size.w * item.gridIndex.col);
			yPos = _guiYPos + (grid.size.h * item.gridIndex.row);
			
			var itemDragged = false;
			if (global.DragItem != noone)
			{
				if (global.DragItem.sourceType == item.sourceType)
				{
					if (item.gridIndex.col == global.DragItem.gridIndex.col && item.gridIndex.row == global.DragItem.gridIndex.row)
					{
						itemDragged = true;
					}
				}
			}
			
			// Highlight item
			if (!itemDragged)
			{
				var outlineColor = make_colour_rgb(30, 30, 18);
				draw_rectangle_color(
					xPos, yPos,
					xPos + (grid.size.w * item.size.w),
					yPos + (grid.size.h * item.size.h),
					outlineColor, outlineColor, outlineColor, outlineColor, false
				);
				
				var gridColor = make_colour_rgb(187, 169, 140);
				if (!item.known) {
					gridColor = make_colour_rgb(3, 3, 3);//make_colour_rgb(13, 13, 8);
				} else if ((mouseHoverIndex != noone && global.DragItem == noone) || drawDragItem)
				{
					if ((mouseHoverIndex.col >= item.gridIndex.col && mouseHoverIndex.col <= (item.gridIndex.col + item.size.w - 1) &&
						mouseHoverIndex.row >= item.gridIndex.row && mouseHoverIndex.row <= (item.gridIndex.row + item.size.h - 1)) || drawDragItem)
					{
						gridColor = make_colour_rgb(167, 75, 49);
					}
				}
				
				draw_rectangle_color(
					xPos + grid.outline,
					yPos + grid.outline,
					xPos + (grid.size.w * item.size.w) - grid.outline,
					yPos + (grid.size.h * item.size.h) - grid.outline,
					gridColor, gridColor, gridColor, gridColor, false
				);
			}
			
			// Calculate icon scale and draw the sprite
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
			
			if (item.known)
			{
				draw_sprite_ext(
					item.icon, 0,
					xPos + ((grid.size.w * 0.5) * item.size.w),
					yPos + ((grid.size.h * 0.5) * item.size.h),
					iconScale, iconScale, iconRotation, c_white, iconAlpha
				);
			} else {
				if (item.gridIndex == searchIndex)
				{
					shader_set(shdrSearchSprite);
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
			
		}
		
		mouseHoverIndex = GetMouseHoverIndex(_guiXPos, _guiYPos, grid);
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
	
	static InventorySearch = function()
	{
		if (searchIndex != noone)
		{
			if (searchTimer-- <= 0)
			{
				var item = GetItemByGridIndex(searchIndex);
				item.known = true;
				
				searchIndex = noone;
				searchTimer = 0;
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
						var item = GetItemByGridIndex(itemGridIndex);
						if (item != noone)
						{
							var rotatedItem = item.Clone();
							rotatedItem.Rotate();
							if (IsGridAreaEmpty(rotatedItem.gridIndex.col, rotatedItem.gridIndex.row, rotatedItem, rotatedItem.sourceType, rotatedItem.gridIndex))
							{
								// Clear old fill area
								FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, noone);
								item.Rotate();
								
								// Fill new area
								FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, item.gridIndex);
							} else {
								AddMessageLog("Can't rotate " + item.name);
							}
						}
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
						if (IsGridAreaEmpty(newGridIndex.col, newGridIndex.row, global.DragItem, global.DragItem.sourceType, global.DragItem.gridIndex))
						{
							var inventorySource = (global.DragItem.sourceType == INVENTORY_TYPE.PlayerBackpack) ? global.PlayerBackpack : global.ObjLootContainer.loot;
							if (inventorySource != noone)
							{
								if (type == global.DragItem.sourceType)
								{
									var item = inventorySource.GetItemByGridIndex(global.DragItem.gridIndex);
									
									// Clear previous spot
									FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, noone);
									
									// Set rotation
									if (global.DragItem.rotated != item.rotated)
									{
										item.Rotate();
									}
									
									// Set new spot
									item.gridIndex = newGridIndex;
									FillGridArea(item.gridIndex.col, item.gridIndex.row, item.size, item.gridIndex.Clone());
								} else {
									var newItem = AddItem(global.DragItem.Clone(), newGridIndex, global.DragItem.known);
									if (newItem != noone)
									{
										with (inventorySource)
										{
											var oldItem = GetItemByGridIndex(global.DragItem.gridIndex);
											RemoveItemByGridIndex(oldItem.gridIndex);
										}
									} else {
										// MESSAGE LOG
										AddMessageLog(string(global.DragItem.name) + " transfer failed!");	
									}
								}
							}
						} else {
							// MESSAGE LOG
							AddMessageLog(string(global.DragItem.name) + " doesn't fit!");
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
							searchIndex = item.gridIndex;
							searchTimer = searchDuration;
						}
					}
				} else if (mouse_check_button_released(mb_right))
				{
					if (type == INVENTORY_TYPE.PlayerBackpack)
					{
						if (global.ObjGun != noone)
						{
							var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							if (itemGridIndex != noone)
							{
								var item = GetItemByGridIndex(itemGridIndex);
								if (item != noone)
								{
									if (item.type == "Primary_Weapon")
									{
										global.ObjGun.primaryWeapon = item;
										global.ObjGun.initWeapon = true;
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
							if (global.ObjLootContainer != noone)
							{
								if (global.ObjLootContainer.loot != noone)
								{
									with (global.ObjLootContainer.loot)
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
