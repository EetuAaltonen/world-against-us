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
				if (is_undefined(global.ObjMouse.dragItem))
				{
					// ROTATE
					if (keyboard_check_released(ord("R")))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (itemGridIndex != noone)
						{
							var isItemRotated = inventory.GetItemByGridIndex(itemGridIndex).isRotated;
							inventory.MoveAndRotateItemByGridIndex(itemGridIndex, itemGridIndex, !isItemRotated);
						}
					}
					// IDENTIFY ITEM
					else if (mouse_check_button_released(mb_middle))
					{
						var itemGridIndex = inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col];
						if (itemGridIndex != noone)
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
						if (itemGridIndex != noone)
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
						if (itemGridIndex != noone)
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
							GUIOnDragItemReleased(inventory, mouseHoverIndex);
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
		if (parentWindow.isFocused)
		{
			mouseHoverIndex = undefined;
			
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
					var iconRotation = CalculateItemIconRotation(item.isRotated);
				
					// DRAW BACKGROUND
					var gridSpriteIndex = 0;
					if (!item.known) {
						gridSpriteIndex = 2;
					} else if ((!is_undefined(mouseHoverIndex) && is_undefined(global.ObjMouse.dragItem)))
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
					
					// ITEM NAME
					var nameTextPos = new Vector2(
						xPos + 5,
						yPos
					);
					DrawItemAltText(item.name, nameTextPos.X, nameTextPos.Y + 1);
				
					// ITEM ALT TEXT
					var altTextPos = new Vector2(xPos + 5, yPos + (gridCellSize.h * item.size.h) - 15);
					if (item.type == "Magazine")
					{
						var altText = string("{0} / {1}", item.metadata.bullet_count, item.metadata.magazine_size);
						DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
					} else if (item.type == "Medicine")
					{
						var altText = string("{0} / {1}", item.metadata.healing_left, item.metadata.healing_value);
						DrawItemAltText(altText, altTextPos.X, altTextPos.Y);
					} else {
						if (item.quantity > 1)
						{
							DrawItemAltText(item.quantity, altTextPos.X, altTextPos.Y);
						}
					}
				}
			}
			
			// MOUSE DEBUG INFO
			if (!is_undefined(mouseHoverIndex))
			{
				var mousePosition = MouseGUIPosition();
				draw_text(mousePosition.X + 5, mousePosition.Y + 20, string(inventory.gridData[mouseHoverIndex.row][mouseHoverIndex.col]));
			}
			
			// DRAW DRAGGED ITEM
			DrawDraggedItem();
		}
	}
	
	static DrawDraggedItem = function()
	{
		if (!is_undefined(global.ObjMouse.dragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var xHoverPos = position.X + (gridCellSize.w * mouseHoverIndex.col);
				var yHoverPos = position.Y + (gridCellSize.h * mouseHoverIndex.row);
				
				// DRAW BACKGROUND
				// TODO: Check available interactions
				/*var isGridIndexEmpty = inventory.IsGridAreaEmpty(mouseHoverIndex.col, mouseHoverIndex.row, global.ObjMouse.dragItem, global.ObjMouse.dragItem.sourceInventory, global.ObjMouse.dragItem.grid_index)
				var backgroundIndex = (isGridIndexEmpty) ? 0 : 3;*/
				draw_sprite_ext(sprGUIItemBg, 0, xHoverPos, yHoverPos, global.ObjMouse.dragItem.size.w * gridSpriteScale, global.ObjMouse.dragItem.size.h * gridSpriteScale, 0, #0fb80f, 0.2);
				
				// DRAW ITEM
				var iconScale = CalculateItemIconScale(global.ObjMouse.dragItem, gridCellSize);
				var iconRotation = CalculateItemIconRotation(global.ObjMouse.dragItem.isRotated);
				/*draw_sprite_ext(
					global.ObjMouse.dragItem.icon, 0,
					xHoverPos + ((inventory.grid.size.w * 0.5) * global.ObjMouse.dragItem.size.w * gridSpriteScale),
					yHoverPos + ((inventory.grid.size.h * 0.5) * global.ObjMouse.dragItem.size.h * gridSpriteScale),
					iconScale, iconScale, iconRotation, c_white, 0.4
				);*/
				
				// ITEM QUANTITY
				//DrawItemAltText(global.ObjMouse.dragItem.quantity, xHoverPos, yHoverPos);
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