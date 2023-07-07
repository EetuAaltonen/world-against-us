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
				if (is_undefined(global.ObjMouse.dragItem))
				{
					// ROTATE
					if (keyboard_check_released(ord("R")))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var isItemRotated = inventory.GetItemByGridIndex(itemGridIndex).is_rotated;
							inventory.MoveAndRotateItemByGridIndex(itemGridIndex, itemGridIndex, !isItemRotated);
						}
					}
					// IDENTIFY ITEM
					else if (mouse_check_button_released(mb_middle))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (!is_undefined(item))
							{
								inventory.identifyIndex = item.grid_index;
								inventory.identifyTimer = inventory.identifyDuration;
							}
						}
					}
					// OPEN ACTION MENU
					else if (mouse_check_button_released(mb_right))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
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
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (!is_undefined(itemGridIndex))
						{
							var item = inventory.GetItemByGridIndex(itemGridIndex);
							if (item.known)
							{
								global.ObjMouse.dragItem = item.Clone();
									
								// FORCE UPDATE MOUSE HOVER INDEX
								// TO PREVENT FLICKERING
								UpdateMouseHoverIndex();
							}
						}
					}
				} else {
					// DROP DRAG ITEM
					if (mouse_check_button_released(mb_left))
					{
						if (!is_undefined(global.ObjMouse.dragItem))
						{
							OnReleasedGUIDragItem(inventory, mouseHoverIndex);
							global.ObjMouse.dragItem = undefined;
						}
					}
					// ROTATE DRAG ITEM
					else if (keyboard_check_released(ord("R")))
					{
						global.ObjMouse.dragItem.Rotate();
						
						// FORCE UPDATE MOUSE HOVER INDEX
						// TO PREVENT FLICKERING
						UpdateMouseHoverIndex();
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
					mousePositionToGrid.X -= ((gridCellSize.w * 0.5) * (global.ObjMouse.dragItem.size.w - 1));
					mousePositionToGrid.Y -= ((gridCellSize.h * 0.5) * (global.ObjMouse.dragItem.size.h - 1));
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
				
			// CHECK IF ITEM IS DRAGGED
			var itemDragged = false;
			if (!is_undefined(global.ObjMouse.dragItem))
			{
				if (global.ObjMouse.dragItem.sourceInventory.inventoryId == item.sourceInventory.inventoryId)
				{
					itemDragged = (item.grid_index.col == global.ObjMouse.dragItem.grid_index.col && item.grid_index.row == global.ObjMouse.dragItem.grid_index.row);
				}
			}
				
			// SKIP DRAWING IF ITEM IS DRAGGED
			if (!itemDragged)
			{
				var iconScale = CalculateItemIconScale(item, gridCellSize);
				var iconRotation = CalculateItemIconRotation(item.is_rotated);
				
				// DRAW BACKGROUND
				var gridSpriteIndex = 0;
				if (!item.known) {
					if (item.grid_index == inventory.identifyIndex)
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
					
				// IMAGE INDEX
				var imageIndex = 0;
				if (item.type == "Primary_Weapon")
				{
					imageIndex = is_undefined(item.metadata.magazine);
				}
					
				draw_sprite_ext(
					item.icon, imageIndex,
					xPos + ((gridCellSize.w * 0.5) * item.size.w),
					yPos + ((gridCellSize.h * 0.5) * item.size.h),
					iconScale, iconScale, iconRotation, c_white, 1
				);
				shader_reset();
				
				if (item.known)
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
						yPos
					);
					DrawItemAltText(item.short_name, nameTextPos.X, nameTextPos.Y + 1);
					
					// DRAW ITEM ALT TEXT BACKGROUND
					draw_sprite_ext(
						sprGUIBg, gridSpriteIndex, xPos + textBgPadding, yPos + (item.size.h * gridCellSize.h) - textBgHeight - textBgPadding,
						item.size.w * gridCellSize.w - (textBgPadding * 2), textBgHeight,
						0, c_white, textBgAlpha
					);
					
					// ITEM ALT TEXT
					var altTextPos = new Vector2(xPos + 5, yPos + (item.size.h * gridCellSize.h) - 20);
					switch (item.type)
					{
						case "Magazine":
						{
							var altText = string("{0} / {1}", item.metadata.GetBulletCount(), item.metadata.capacity);
							DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
						} break;
						case "Medicine":
						{
							var altText = string("{0} / {1}", item.metadata.healing_left, item.metadata.healing_value);
							DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
						} break;
						case "Fuel":
						{
							var altText = string("{0} / {1}", item.metadata.fuel_left, item.metadata.fuel_value);
							DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
						} break;
						default:
						{
							if (item.quantity > 1)
							{
								DrawItemAltText(string("{0}x", item.quantity), altTextPos.X, altTextPos.Y);
							}
						} break;
					}
				}
			}
		}
		
		// DRAW DRAGGED ITEM
		if (!is_undefined(global.ObjMouse.dragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var dragItem = global.ObjMouse.dragItem;
				var xHoverPos = position.X + (gridCellSize.w * mouseHoverIndex.col);
				var yHoverPos = position.Y + (gridCellSize.h * mouseHoverIndex.row);
				var isGridAreaEmpty = inventory.IsGridAreaEmpty(
					mouseHoverIndex.col, mouseHoverIndex.row,
					dragItem, dragItem.sourceInventory, dragItem.grid_index
				);
				var gridAreaColor = isGridAreaEmpty ? #0fb80f : #b80f0f;
				draw_sprite_ext(
					sprGUIItemBg, 0,
					xHoverPos, yHoverPos,
					dragItem.size.w * gridSpriteScale,
					dragItem.size.h * gridSpriteScale,
					0, gridAreaColor, 0.2
				);
			}
		}
			
		// MOUSE DEBUG INFO
		if (global.DEBUGMODE)
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var mousePosition = MouseGUIPosition();
				draw_text(mousePosition.X + 5, mousePosition.Y + 50, string(inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
			}
		}
	}
	
	static DrawItemAltText = function(_altText, _guiXPos, _guiYPos)
	{
		draw_set_font(font_small_bold);
		draw_text(_guiXPos, _guiYPos, string(_altText));
		draw_set_font(font_default);
	}
}