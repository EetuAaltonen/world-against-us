function WindowInventoryGrid(_elementId, _relativePosition, _size, _backgroundColor, _inventory) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	inventory = _inventory;
	grid_cell_size = new Size(0, 0);
	grid_sprite = sprGUIGrid;
	grid_sprite_scale = 0;
	
	itemBackgroundSprite = sprGUIItemBg;
	mouseHoverIndex = undefined;
	is_initialized = false;
	
	Initialize();
	
	static OnDestroy = function()
	{
		// DO NOT DESTROY THE INVENTORY
		// BECAUSE IT'S A REFERENCE
		return;	
	}
	
	static Initialize = function()
	{
		if (!is_initialized)
		{
			if (!is_undefined(inventory))
			{
				grid_cell_size.w = size.w / inventory.grid.columns;
				grid_cell_size.h = size.w / inventory.grid.columns;
				grid_sprite_scale = grid_cell_size.w / sprite_get_width(grid_sprite);
				size.h = (grid_cell_size.h * inventory.size.rows);
			
				is_initialized = true;
			}
		}
	}
	
	static UpdateContent = function()
	{
		if (!is_initialized) return;
		
		if (!is_undefined(inventory.identify_index))
		{
			inventory.InventoryIdentify();
		}
		
		// UPDATE MOUSE HOVER INDEX
		UpdateMouseHoverIndex();
	}
	
	static CheckContentInteraction = function()
	{
		if (!is_initialized) return;
		if (is_undefined(mouseHoverIndex)) return;
		if (!is_undefined(inventory.identify_index)) return;
		
		// CHECK FOR INTERACTIONS
		if (!is_undefined(global.ObjMouse.dragItem))
		{
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
		} else {
			// ROTATE
			if (keyboard_check_released(ord("R")))
			{
				var itemGridIndex = inventory.grid_data[mouseHoverIndex.row][mouseHoverIndex.col];
				if (!is_undefined(itemGridIndex))
				{
					var item = inventory.GetItemByGridIndex(itemGridIndex);
					if (!is_undefined(item))
					{
						var newRotation = !item.is_rotated;
						if (inventory.RotateItemByGridIndex(itemGridIndex, newRotation))
						{
							// NETWORKING ROTATE ITEM
							if (global.MultiplayerMode)
							{
								if (IsInventoryContainer(inventory.type))
								{
									var containerInventoryActionInfo = new ContainerInventoryActionInfo(inventory.inventory_id, itemGridIndex, undefined, newRotation, undefined, undefined);
									var networkPacketHeader = new NetworkPacketHeader(MESSAGE_TYPE.CONTAINER_INVENTORY_ROTATE_ITEM);
									var networkPacket = new NetworkPacket(
										networkPacketHeader,
										containerInventoryActionInfo,
										PACKET_PRIORITY.DEFAULT,
										AckTimeoutFuncResend
									);
									if (!global.NetworkHandlerRef.AddPacketToQueue(networkPacket))
									{
										show_debug_message("Failed to rotate item in container inventory");
									}
								}
							}
						}
					}
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
						inventory.identify_timer.StartTimer();
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
						if (item.is_known)
						{
							GUIOpenItemActionMenu(item);
						}
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
		}
	}
	
	static UpdateMouseHoverIndex = function()
	{
		if (!is_initialized) return;
		
		mouseHoverIndex = undefined;
		
		if (parentWindow.isFocused)
		{
			var mousePositionToGrid = MouseGUIPosition();
			if (point_in_rectangle(mousePositionToGrid.X, mousePositionToGrid.Y, position.X, position.Y, position.X + size.w, position.Y + size.h))
			{
				if (!is_undefined(global.ObjMouse.dragItem))
				{
					var dragItemData = global.ObjMouse.dragItem.item_data;
					mousePositionToGrid.X -= ((grid_cell_size.w * 0.5) * (dragItemData.size.w - 1));
					mousePositionToGrid.Y -= ((grid_cell_size.h * 0.5) * (dragItemData.size.h - 1));
				}
				
				var indexX = floor((mousePositionToGrid.X - position.X) / grid_cell_size.w);
				var indexY = floor((mousePositionToGrid.Y - position.Y) / grid_cell_size.h);
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
		if (!is_initialized) return;
		
		// DRAW GRID BACKGROUND
		var xPos = position.X;
		var yPos = position.Y;
		
		for (var i = 0; i < inventory.grid.rows; i++)
		{
			for (var j = 0; j < inventory.grid.columns; j++)
			{
				var gridSpriteIndex = 0;
				
				draw_sprite_ext(grid_sprite, gridSpriteIndex, xPos, yPos, grid_sprite_scale, grid_sprite_scale, 0, c_white, 1);
				xPos += grid_cell_size.w;
			}
			yPos += grid_cell_size.h;
			xPos = position.X;
		}

		// DRAW ITEMS
		var itemCount = inventory.GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = inventory.GetItemByIndex(i);
			xPos = position.X + (grid_cell_size.w * item.grid_index.col);
			yPos = position.Y + (grid_cell_size.h * item.grid_index.row);
			var iconBaseScale = 0.8;
			// DRAW ITEM BACKGROUND
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
			draw_sprite_ext(itemBackgroundSprite, gridSpriteIndex, xPos, yPos, item.size.w * grid_sprite_scale, item.size.h * grid_sprite_scale, 0, c_white, 0.5);
				
			// DRAW ITEM
			var imageAlpha = 1;
			if (item.is_known)
			{
				if (!is_undefined(global.ObjMouse.dragItem))
				{
					imageAlpha = CombineItems(global.ObjMouse.dragItem.item_data, item, true) ? imageAlpha : 0.2;
				}
			} else {
				// TODO: Fix shader while identifying
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
			
			DrawItem(
				item, 0, iconBaseScale, imageAlpha,
				new Vector2(xPos + ((grid_cell_size.w * 0.5) * item.size.w), yPos + ((grid_cell_size.h * 0.5) * item.size.h)),
				new Size(grid_cell_size.w * item.size.w, grid_cell_size.h * item.size.h),
				[DRAW_ITEM_FLAGS.NameBg, DRAW_ITEM_FLAGS.NameShort,
				DRAW_ITEM_FLAGS.AltTextBg, DRAW_ITEM_FLAGS.AltText]
			);
			
			// RESET SHADER
			shader_reset();
		}
		
		// DRAW DRAG ITEM INDICATOR
		if (!is_undefined(global.ObjMouse.dragItem))
		{
			if (!is_undefined(mouseHoverIndex))
			{
				var xHoverPos = position.X + (grid_cell_size.w * mouseHoverIndex.col);
				var yHoverPos = position.Y + (grid_cell_size.h * mouseHoverIndex.row);
				var dragItemData = global.ObjMouse.dragItem.item_data;
				
				var isGridAreaEmpty = inventory.IsGridAreaEmpty(
					mouseHoverIndex.col, mouseHoverIndex.row,
					dragItemData, dragItemData.sourceInventory, dragItemData.grid_index
				);
				var gridAreaColor = (inventory.IsItemWhitelisted(dragItemData) && isGridAreaEmpty) ? #0fb80f : #b80f0f;
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
					dragItemData.size.w * grid_sprite_scale,
					dragItemData.size.h * grid_sprite_scale,
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
}