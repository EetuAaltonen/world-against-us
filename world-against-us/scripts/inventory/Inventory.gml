function Inventory(_inventory_id, _type, _size = { columns: 10, rows: 10 }, _filter_array = []) constructor
{
	inventory_id = _inventory_id
    items = ds_list_create();
	type = _type;
	size = _size;
	filter_array = _filter_array;
	
	grid_data = [];
	grid = {
		columns: size.columns,
		rows: size.rows,
		size: {
			w: 48,
			h: 48
		}
	};
	InitGridData();
	
	// Item search
	identify_index = undefined;
	identify_duration = TimerFromSeconds(2);
	identify_timer = 0;
	
	static ToJSONStruct = function()
	{
		var itemArray = [];
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = items[| i];
			array_push(itemArray, item.ToJSONStruct());
		}
		return {
			inventory_id: inventory_id,
			inventory_type: type,
			items: itemArray
		}
	}
	
	static InitGridData = function()
	{
		// RESET GRID DATA
	    for (var i = 0; i < size.rows; i++) {
		  for (var j = 0; j < size.columns; j ++) {
		    grid_data[i, j] = undefined;
		  }
		}
	}
	
	static GetItemCount = function()
    {
		return ds_list_size(items);
    }
	
	static ClearItems = function()
	{
		// CLEAR ITEMS
		ds_list_clear(items);
		InitGridData();
	}

    static AddItem = function(_item, _new_grid_index = undefined, _new_is_rotated = false, _new_is_known = true, _ignore_network = false)
    {
		var addedItemGridIndex = undefined;
		var isItemStacked = false;
		
		if (IsItemWhiteListed(_item))
		{
			var cloneItem = _item.Clone();
			if (cloneItem.is_rotated != _new_is_rotated)
			{
				cloneItem.Rotate();	
			}
			
			if (!is_undefined(_new_grid_index))
			{
				cloneItem.grid_index = _new_grid_index.Clone();
			} else {
				var emptyIndex = FindEmptyIndex(cloneItem);
				var stackGridIndex = StackItem(cloneItem, emptyIndex);
				if (!is_undefined(stackGridIndex))
				{
					// IF ITEM IS FULLY STACKED
					isItemStacked = true;
					addedItemGridIndex = stackGridIndex;
				} else {
					cloneItem.grid_index = emptyIndex ?? FindEmptyIndex(cloneItem);
				}
			}
			
			// CHECK IF ITEM IS ALREADY STACKED
			if (!isItemStacked)
			{
				if (!is_undefined(cloneItem.grid_index))
				{
					cloneItem.is_known = _new_is_known;
					cloneItem.sourceInventory = self;
				
					FillGridArea(cloneItem.grid_index.col, cloneItem.grid_index.row, cloneItem.size, cloneItem.grid_index.Clone());
			
					if (!_ignore_network)
					{
						if (type == INVENTORY_TYPE.LootContainer)
						{
							// NETWORKING CONTAINER DELETE ITEM
							var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_ADD_ITEM);
							var jsonData = json_stringify(cloneItem);
				
							buffer_write(networkBuffer, buffer_text , inventory_id);
							buffer_write(networkBuffer, buffer_text, jsonData);
							global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
						}
					}
					ds_list_add(items, cloneItem);
					addedItemGridIndex = cloneItem.grid_index.Clone();
				} else {
					// LOG NOTIFICATION
					global.NotificationHandlerRef.AddNotification(
						new Notification(
							undefined,
							string("{0} doesn't fit!", _item.name),
							undefined,
							NOTIFICATION_TYPE.Log
						)
					);
				}
			}
		} else {
			// LOG NOTIFICATION
			global.NotificationHandlerRef.AddNotification(
				new Notification(
					undefined,
					string("{0} is not whitelisted!", _item.name),
					undefined,
					NOTIFICATION_TYPE.Log
				)
			);
		}
		return addedItemGridIndex;
    }
	
	static AddMultipleItems = function(_itemArray)
	{
		var isAddingCompleted = false;
		
		if (!is_undefined(_itemArray))
		{
			var itemCount = array_length(_itemArray);
			for (var i = 0; i < itemCount; i++)
			{
				var item = array_pop(_itemArray);
				if (!is_undefined(item))
				{
					var addedItemGridIndex = AddItem(item, item.grid_index, item.is_rotated, item.is_known);
					if (is_undefined(addedItemGridIndex)) break;
				}
			}
			isAddingCompleted = (array_length(_itemArray) <= 0);
		}
		
		return isAddingCompleted;
	}
	
	static StackItem = function(_sourceItem, _priority_grid_index = undefined)
	{
		var stackGridIndex = undefined;
		if (_sourceItem.max_stack > 1)
		{
			var itemCount = GetItemCount();
			for (var i = 0; i < itemCount; i++)
			{
				var item = GetItemByIndex(i);
				if (item.Compare(_sourceItem))
				{
					var isPriorityGridIndexSmaller = (!is_undefined(_priority_grid_index)) ? _priority_grid_index.IsSmaller(item.grid_index) : false;
					
					// IGNORE STACKING IF ITEM STACKS ARE ALREADY FULL
					// AND CAN BE ADDED WITH SMALLER (PRIORITY) GRID INDEX
					if ((_sourceItem.quantity < _sourceItem.max_stack && item.quantity < item.max_stack) || !isPriorityGridIndexSmaller)
					{
						item.Stack(_sourceItem);
						if (_sourceItem.quantity <= 0)
						{
							stackGridIndex = item.grid_index.Clone();
						}
					}
				}
			}
		}
		
		return stackGridIndex;
	}
	
	static ReplaceWithRollback = function(_oldItem, _newItem)
    {
		_oldItem.sourceInventory.RemoveItemByGridIndex(_oldItem.grid_index);
		var replacedItemGridIndex = _oldItem.sourceInventory.AddItem(_newItem);
		if (is_undefined(replacedItemGridIndex))
		{
			// ROLLBACK IF NEW ITEM DOESN'T FIT
			_oldItem.sourceInventory.AddItem(_oldItem, _oldItem.grid_index, _oldItem.is_rotated);
		}
		
		return replacedItemGridIndex;
    }
	
	static SwapWithRollback = function(_sourceItem, _targetItem)
	{
		var isItemSwapped = false;
		var swappedTargetItemGridIndex = _sourceItem.sourceInventory.ReplaceWithRollback(_sourceItem, _targetItem);
		if (!is_undefined(swappedTargetItemGridIndex))
		{
			var swappedSourceItemGridIndex = _targetItem.sourceInventory.ReplaceWithRollback(_targetItem, _sourceItem);
			if (!is_undefined(swappedSourceItemGridIndex))
			{
				isItemSwapped = true;
			} else {
				_sourceItem.sourceInventory.RemoveItemByGridIndex(swappedTargetItemGridIndex);
				_sourceItem.sourceInventory.AddItem(_sourceItem, _sourceItem.grid_index, _sourceItem.is_rotated, _sourceItem.is_known);
			}
		}
		
		return isItemSwapped;
	}
	
	static GetItemByIndex = function(_index)
    {
		return items[| _index];
    }
	
	static GetItemByGridIndex = function(_gridIndex)
    {
		var foundItem = undefined;
		var itemCount = GetItemCount();
		
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItemByIndex(i);
			if (item.grid_index.col == _gridIndex.col &&
				item.grid_index.row == _gridIndex.row)
			{
				foundItem = items[| i];
				break;
			}
		}
		return foundItem;
    }
	
	static MoveAndRotateItemByGridIndex = function(_gridIndex, _newGridIndex, _isRotated)
	{
		var item = GetItemByGridIndex(_gridIndex);
		var originalRotation = item.is_rotated;
		
		if (!is_undefined(item))
		{
			// Clear previous spot
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, undefined);
			
			// Set rotation
			if (_isRotated != item.is_rotated)
			{
				item.Rotate();
			}
			
			if (IsGridAreaEmpty(_newGridIndex.col, _newGridIndex.row, item, item.sourceInventory, item.grid_index))
			{
				if (type == INVENTORY_TYPE.LootContainer)
				{
					// NETWORKING CONTAINER DELETE ITEM
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_MOVE_AND_ROTATE_ITEM);
					var jsonData = json_stringify(item);
				
					buffer_write(networkBuffer, buffer_text , inventory_id);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.col);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.row);
					buffer_write(networkBuffer, buffer_bool, item.is_rotated);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
				
				item.grid_index = _newGridIndex;
			} else {
				// Reverse rotation if item doesn't fit
			    if (item.is_rotated != originalRotation) {
			        item.Rotate();
			    }
			}
			
			// Set new spot
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, item.grid_index.Clone());
		}
	}
	
	static IsItemWhiteListed = function(_item)
    {
		return (array_length(filter_array) == 0) || (
			ArrayContainsValue(filter_array, _item.category) ||
			ArrayContainsValue(filter_array, _item.name)
		);
    }
	
	static RemoveItemByIndex = function(_index)
    {
		var item = GetItemByIndex(_index);
		if (!is_undefined(item))
		{
			if (type == INVENTORY_TYPE.LootContainer)
			{
				// NETWORKING CONTAINER DELETE ITEM
				var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_DELETE_ITEM);
				var jsonData = json_stringify(item);
			
				buffer_write(networkBuffer, buffer_text , inventory_id);
				buffer_write(networkBuffer, buffer_text, jsonData);
				global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
			}
		
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, undefined);
			ds_list_delete(items, _index);
		}
    }
	
	static RemoveItemByGridIndex = function(_gridIndex)
    {
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItemByIndex(i);
			if (item.grid_index.col == _gridIndex.col &&
				item.grid_index.row == _gridIndex.row)
			{
				RemoveItemByIndex(i);
				break;
			}
		}
    }
	
	static FindEmptyIndex = function(_item)
	{
		var index = undefined;
		for (var i = 0; i < size.rows; i++)
		{
			if (!is_undefined(index)) break;
			for (var j = 0; j < size.columns; j++)
			{
				if (!is_undefined(index)) break;
				if (is_undefined(grid_data[i][j]))
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
	
	static IsItemInsideGridArea = function(_col, _row, _item)
	{
		return ((_col + _item.size.w - 1) < array_length(grid_data[0]) && (_row + _item.size.h - 1) < array_length(grid_data));
	}
	
	static IsGridAreaEmpty = function(_col, _row, _item, _ignoreSource = undefined, _ignoreGridIndex = undefined)
	{
		var isEmpty = true;
		if (IsItemInsideGridArea(_col, _row, _item))
		{
			for (var i = _row; i < (_row + _item.size.h); i++)
			{
				if (!isEmpty) break;
				for (var j = _col; j < (_col + _item.size.w); j++)
				{
					if (!isEmpty) break;
					var gridIndex = grid_data[i][j];
					if (!is_undefined(gridIndex))
					{
						if (!is_undefined(_ignoreSource) && !is_undefined(_ignoreGridIndex))
						{
							if (inventory_id == _ignoreSource.inventory_id)
							{
								if (!gridIndex.Compare(_ignoreGridIndex))
								{
									isEmpty = false;
								}
							} else {
								isEmpty = false;
							}
						} else {
							isEmpty = false;
						}
					}
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
				grid_data[i][j] = _value;
			}
		}
	}
	
	static InventoryIdentify = function()
	{
		if (!is_undefined(identify_index))
		{
			if (identify_timer-- <= 0)
			{
				var item = GetItemByGridIndex(identify_index);
				item.is_known = true;
				
				if (type == INVENTORY_TYPE.LootContainer)
				{
					// NETWORKING CONTAINER DELETE ITEM
					var networkBuffer = global.ObjNetwork.client.CreateBuffer(MESSAGE_TYPE.CONTAINER_IDENTIFY_ITEM);
					var jsonData = json_stringify(item);
			
					buffer_write(networkBuffer, buffer_text , inventory_id);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
				
				// RESET INDENTIFY TARGET AND TIMER
				identify_index = undefined;
				identify_timer = 0;
			}
		}
	}
}
