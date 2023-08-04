function WindowInventoryGrid(_elementId, _relativePosition, _size, _backgroundColor, _inventory) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	inventory = _inventory;
	
	gridCellSize = new Size(size.w / inventory.grid.columns, size.w / inventory.grid.columns);
	gridSprite = sprGUIGrid;
	gridSpriteScale = gridCellSize.w / sprite_get_width(gridSprite);
	size = new Size(size.w, (gridCellSize.h * inventory.size.rows));
	
	itemBackgroundSprite = sprGUIItemBg;
	
	mouseHoverIndex = undefined;
	
	static UpdateContent = function()
	{
		if (!is_undefined(inventory.identify_index))
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
			if (is_undefined(inventory.identify_index))
			{
				if (is_undefined(global.ObjMouse.dragItem))
				{
					// ROTATE
					if (keyboard_check_released(ord("R")))
					{
						var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var isItemRotated = inventory.GetItemByGridIndex(itemGridIndex).is_rotated;
							inventory.MoveAndRotateItemByGridIndex(itemGridIndex, itemGridIndex, !isItemRotated);
						}
					}
					// IDENTIFY ITEM
					else if (mouse_check_button_released(mb_middle))
					{
						var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (!is_undefined(item))
							{
								inventory.identify_index = item.grid_index;
								inventory.identify_timer = inventory.identify_duration;
							}
						}
					}
					// OPEN ACTION MENU
					else if (mouse_check_button_released(mb_right))
					{
						var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (!is_undefined(item))
							{
								GUIOpenItemActionMenu(item);
							}
						}
					}
					else if (keyboard_check(vk_control))
					{
						// QUICK TRANSFER
						if (mouse_check_button_released(mb_left))
						{
							GUIOnItemQuickTransfer(inventory, mouseHoverIndex);
						}
					}
					// START DRAG ITEM
					// MUST BE LOCATED UNDER CTRL CHECK
					else if (mouse_check_button_pressed(mb_left))
					{
						var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (item.is_known)
							{
								OnPressedGUIDragItemStart(item);
							}
						}
					}
				} else {
					// DROP DRAG ITEM
					if (mouse_check_button_released(mb_left))
					{
						if (!OnReleasedGUIDragItem(inventory, mouseHoverIndex))
						{
							// RESTORE ITEM IF DROPPING IS INTERRUPTED
							global.ObjMouse.dragItem.RestoreOriginalItem();
						}
						
						global.ObjMouse.dragItem = undefined;
					}
					// SPLIT DRAG ITEM
					else if (mouse_check_button_released(mb_right))
					{
						if (OnReleasedGUIDragItemSplit(inventory, mouseHoverIndex))
						{
							// REMOVE ITEM IF STACK IS EMPTY AFTER SPLIT ACTION
							global.ObjMouse.dragItem = undefined;
						}
					}
					// ROTATE DRAG ITEM
					else if (keyboard_check_released(ord("R")))
					{
						global.ObjMouse.dragItem.item_data.Rotate();
					}
				}
			}
		}
	}
	
	static UpdateMouseHoverIndex = function()
	{
		mouseHoverIndex = undefined;
		
		if (parentWindow.isFocused)
		{
			var mousePositionToGrid = MouseGUIPosition();
			if (point_in_rectangle(mousePositionToGrid.X, mousePositionToGrid.Y, position.X, position.Y, position.X + size.w, position.Y + size.h))
			{
				if (!is_undefined(global.ObjMouse.dragItem))
				{
					var dragItemData = global.ObjMouse.dragItem.item_data;
					mousePositionToGrid.X -= ((gridCellSize.w * 0.5) * (dragItemData.size.w - 1));
					mousePositionToGrid.Y -= ((gridCellSize.h * 0.5) * (dragItemData.size.h - 1));
				}
				
				var indexX = floor((mousePositionToGrid.X - position.X) / gridCellSize.w);
				var indexY = floor((mousePositionToGrid.Y - position.Y) / gridCellSize.h);
				mouseHoverIndex = new GridIndex(
					// MAKE SURE THAT MOUSE HOVER INDEX IS INSIDE INVENTORY INDECES
					clamp(indexX, 0, inventory.size.columns - 1),
					clamp(indexY, 0, inventory.size.rows - 1)
				);
			}
		}
	}
	
	static DrawContent = function()
	{
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
			var item = inventory.GetItemByIndex(i);
			xPos = position.X + (gridCellSize.w * item.grid_index.col);
			yPos = position.Y + (gridCellSize.h * item.grid_index.row);
			
			var itemIconScale = 0.8;
			var iconScale = CalculateItemIconScale(item, new Size(gridCellSize.w * itemIconScale, gridCellSize.h * itemIconScale));
			var iconRotation = CalculateItemIconRotation(item.is_rotated);
			var iconOffset = CalculateSpriteOffsetToCenter(item.icon, iconScale);
			if (item.is_rotated)
			{
				var tempIconOffset = iconOffset.Clone();
				iconOffset.X = tempIconOffset.Y;
				iconOffset.Y = -tempIconOffset.X;
			}
				
			// DRAW BACKGROUND
			var gridSpriteIndex = 0;
			if (!item.is_known) {
				if (item.grid_index == inventory.identify_index)
				{
					gridSpriteIndex = 3;
				} else {
					gridSpriteIndex = 2;
				}
			} else if ((!is_undefined(mouseHoverIndex) && is_undefined(global.ObjMouse.dragItem)))
			{
				if (point_in_rectangle(
					mouseHoverIndex.col, mouseHoverIndex.row,
					item.grid_index.col, item.grid_index.row,
					(item.grid_index.col + (item.size.w - 1)),
					(item.grid_index.row + (item.size.h - 1)))
				)
				{
					gridSpriteIndex = 1;
				}
			}
			draw_sprite_ext(itemBackgroundSprite, gridSpriteIndex, xPos, yPos, item.size.w * gridSpriteScale, item.size.h * gridSpriteScale, 0, c_white, 0.5);
				
			// DRAW ITEM
			if (!item.is_known)
			{
				shader_set(shdrFogSprite);
				if (!is_undefined(inventory.identify_index))
				{
					if (item.grid_index == inventory.identify_index)
					{
						shader_reset();
						shader_set(shdrIdentifySprite);
					}
				}
			}
					
			// IMAGE INDEX
			var imageIndex = 0;
			var imageAlpha = 1;
			
			if (!is_undefined(global.ObjMouse.dragItem))
			{
				imageAlpha = CombineItems(global.ObjMouse.dragItem.item_data, item, true) ? imageAlpha : 0.2;
			}
			
			if (item.category == "Weapon" && item.type != "Melee")
			{
				if (item.metadata.chamber_type == "Magazine")
				{
					imageIndex = is_undefined(item.metadata.magazine);
				}
			}
				
			draw_sprite_ext(
				item.icon, imageIndex,
				xPos + ((gridCellSize.w * 0.5) * item.size.w) + iconOffset.X,
				yPos + ((gridCellSize.h * 0.5) * item.size.h) + iconOffset.Y,
				iconScale, iconScale, iconRotation, c_white, imageAlpha
			);
			shader_reset();
				
			if (item.is_known)
			{
				var textBgPadding = 2;
				var textBgAlpha = 0.2;
				var textBgHeight = 16;
				// DRAW ITEM NAME BACKGROUND
				draw_sprite_ext(
					sprGUIBg, gridSpriteIndex, xPos + textBgPadding, yPos + textBgPadding,
					item.size.w * gridCellSize.w - (textBgPadding * 2), textBgHeight,
					0, c_white, textBgAlpha
				);
					
				// ITEM (SHORT)NAME
				var nameTextPos = new Vector2(
					xPos + 5,
					yPos + 3
				);
				DrawItemAltText(item.short_name, nameTextPos.X, nameTextPos.Y);
					
				// DRAW ITEM ALT TEXT BACKGROUND
				draw_sprite_ext(
					sprGUIBg, gridSpriteIndex, xPos + textBgPadding, yPos + (item.size.h * gridCellSize.h) - textBgHeight - textBgPadding,
					item.size.w * gridCellSize.w - (textBgPadding * 2), textBgHeight,
					0, c_white, textBgAlpha
				);
					
				// ITEM ALT TEXT
				var altTextPos = new Vector2(xPos + 5, yPos + (item.size.h * gridCellSize.h) - 18);
				var altText = GetItemAltText(item);
				if (!is_undefined(altText))
				{
					DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
				}
			}
		}
		
		// DRAW DRAGGED ITEM
		if (!is_undefined(global.ObjMouse.dragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var xHoverPos = position.X + (gridCellSize.w * mouseHoverIndex.col);
				var yHoverPos = position.Y + (gridCellSize.h * mouseHoverIndex.row);
				var dragItemData = global.ObjMouse.dragItem.item_data;
				
				var isGridAreaEmpty = inventory.IsGridAreaEmpty(
					mouseHoverIndex.col, mouseHoverIndex.row,
					dragItemData, dragItemData.sourceInventory, dragItemData.grid_index
				);
				var gridAreaColor = isGridAreaEmpty ? #0fb80f : #b80f0f;
				var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
				if (!is_undefined(itemGridIndex))
				{
					var hoveredItem = inventory.GetItemByGridIndex(itemGridIndex);
					if (!is_undefined(hoveredItem))
					{
						if (CombineItems(dragItemData, hoveredItem, true))
						{
							gridAreaColor = #ffe100;
						}
					}
				}
				
				draw_sprite_ext(
					sprGUIItemBg, 0,
					xHoverPos, yHoverPos,
					dragItemData.size.w * gridSpriteScale,
					dragItemData.size.h * gridSpriteScale,
					0, gridAreaColor, 0.5
				);
			}
		}
			
		// MOUSE DEBUG INFO
		if (global.DEBUGMODE)
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var mousePosition = MouseGUIPosition();
				draw_text(mousePosition.X + 5, mousePosition.Y + 50, string(inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col]));
			}
		}
	}
	
	static DrawItemAltText = function(_altText, _guiXPos, _guiYPos)
	{
		draw_set_font(font_tiny_bold);
		draw_text(_guiXPos, _guiYPos, string(_altText));
		draw_set_font(font_default);
	}
}