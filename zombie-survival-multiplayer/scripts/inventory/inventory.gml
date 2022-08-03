function Inventory(_type) constructor
{
    items = ds_list_create();
	size = {
		columns: 10,
		rows: 10
	};
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
			w: 82,
			h: 82
		},
		outline: 2
	};
	
	showInventory = false;
	
	// Hover effect
	mouseHoverIndex = noone;
	
	static GetItemCount = function()
    {
		return ds_list_size(items);
    }

    static AddItem = function(_item)
    {
		var gridDir = 1;
		_item.gridDir = gridDir;
        _item.gridIndex = FindEmptyIndex(_item.size);
		_item.UpdateIconScale(grid);
		var newValue = _item.gridIndex.Clone();
		
		FillGridArea(_item.gridIndex.col, _item.gridIndex.row, _item.size, newValue);
		ds_list_add(items, _item);
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
	
	static FindEmptyIndex = function(_itemSize, _itemRotation = 1)
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
					if (IsGridAreaEmpty(j, i, _itemSize))
					{
						index = new GridIndex(j, i);
					}
				}
			}
		}
		return index;
	}
	
	static IsGridAreaEmpty = function(_col, _row, _itemSize)
	{
		var isEmpty = true;
		if ((_col + _itemSize.w - 1) < array_length(gridData[0]) &&
			(_row + _itemSize.h - 1) < array_length(gridData))
		{
			for (var i = _row; i < (_row + _itemSize.h); i++)
			{
				if (!isEmpty) break;
				for (var j = _col; j < (_col + _itemSize.w); j++)
				{
					if (!isEmpty) break;
					isEmpty = (gridData[i][j] == noone);
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
	
	static DrawGUI = function(_viewXPos, _viewYPos)
	{
		InventoryInteractions();
		
		var xPos = _viewXPos;
		var yPos = _viewYPos;
		for (var i = 0; i < grid.rows; i++)
		{
			for (var j = 0; j < grid.columns; j++)
			{
				draw_rectangle_color(
					xPos, yPos,
					xPos + grid.size.w,
					yPos + grid.size.h,
					c_white, c_white, c_white, c_white, false
				);
			
				draw_rectangle_color(
					xPos + grid.outline,
					yPos + grid.outline,
					xPos + grid.size.w - grid.outline,
					yPos + grid.size.h - grid.outline,
					c_gray, c_gray, c_gray, c_gray, false
				);
				
				// Debug info
				draw_set_color(c_red);
				var text = (gridData[i][j] != noone) ? 1 : 0;
				draw_text(xPos + 10, yPos + 10, text);
				draw_set_color(c_black);
				
				xPos += grid.size.w;
			}
			yPos += grid.size.h;
			xPos = _viewXPos;
		}
	
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItem(i);
			xPos = _viewXPos + (grid.size.w * item.gridIndex.col);
			yPos = _viewYPos + (grid.size.h * item.gridIndex.row);
			
			draw_rectangle_color(
				xPos, yPos,
				xPos + (grid.size.w * item.size.w),
				yPos + (grid.size.h * item.size.h),
				c_black, c_black, c_black, c_black, false
			);
			
			var gridColor = c_dkgray
			// Highlight item
			if (mouseHoverIndex != noone)
			{
				if (mouseHoverIndex.col >= item.gridIndex.col && mouseHoverIndex.col <= (item.gridIndex.col + item.size.w - 1) &&
					mouseHoverIndex.row >= item.gridIndex.row && mouseHoverIndex.row <= (item.gridIndex.row + item.size.h - 1))
				{
					gridColor = c_orange;
				}
			}
			
			draw_rectangle_color(
				xPos + grid.outline,
				yPos + grid.outline,
				xPos + (grid.size.w * item.size.w) - grid.outline,
				yPos + (grid.size.h * item.size.h) - grid.outline,
				gridColor, gridColor, gridColor, gridColor, false
			);
			
			draw_sprite_ext(
				item.icon, 0,
				xPos + ((grid.size.w * 0.5) * item.size.w),
				yPos + ((grid.size.h * 0.5) * item.size.h),
				item.iconXScale, item.iconYScale, 0, c_white, 1
			);
		}
		
		mouseHoverIndex = GetMouseHoverIndex(_viewXPos, _viewYPos, grid);
		if (mouseHoverIndex != noone)
		{
			draw_text(mouse_x, mouse_y + 100, string(gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
		}
	}
	
	static GetMouseHoverIndex = function(_viewXPos, _viewYPos, grid)
	{
		var mouseHoverIndex = noone;
		var gridWidth = grid.size.w * grid.columns;
		var gridHeight = grid.size.h * grid.rows;
		
		if (mouse_x > _viewXPos && mouse_x < _viewXPos + gridWidth &&
			mouse_y > _viewYPos && mouse_y < _viewYPos + gridHeight)
		{
			var indexX = floor((mouse_x - _viewXPos) / grid.size.w);
			var indexY = floor((mouse_y - _viewYPos) / grid.size.h);
			mouseHoverIndex = new GridIndex(indexX, indexY);
		}
		
		return mouseHoverIndex;
	}
	
	static InventoryInteractions = function()
	{	
		if (mouseHoverIndex	!= noone)
		{
			if (gridData[mouseHoverIndex.row][mouseHoverIndex.col] != noone)
			{
				switch (type)
				{
					case INVENTORY_TYPE.PlayerBackpack:
					{
						if (keyboard_check(vk_shift) && mouse_check_button_released(mb_right))
						{
							var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							RemoveItemByGridIndex(itemGridIndex);
						} else if (keyboard_check(vk_control) && mouse_check_button_released(mb_left))
						{
							var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							var item = GetItemByGridIndex(itemGridIndex);
							if (global.ObjLootContainer != noone)
							{
								if (global.ObjLootContainer.loot != noone)
								{
									with (global.ObjLootContainer.loot)
									{
										AddItem(item.Clone());
									}
									RemoveItemByGridIndex(itemGridIndex);
								}
							}	
						}
					}break;
					case INVENTORY_TYPE.LootContainer:
					{
						if (keyboard_check(vk_control) && mouse_check_button_released(mb_left))
						{
							var itemGridIndex = gridData[mouseHoverIndex.row][mouseHoverIndex.col];
							var item = GetItemByGridIndex(itemGridIndex);
							if (global.PlayerBackpack != noone)
							{
								with (global.PlayerBackpack)
								{
									AddItem(item.Clone());
								}
								RemoveItemByGridIndex(itemGridIndex);
							}
						}
					}break;
				}
			}
		}
	}
}
