function Inventory(_inventoryId, _type, _size = { columns: 10, rows: 10 }, _filterArray = []) constructor
{
	inventoryId = _inventoryId
    items = ds_list_create();
	type = _type;
	size = _size;
	filterArray = _filterArray;
	
	gridData = [];
	grid = {
		columns: size.columns,
		rows: size.rows,
		size: {
			w: 48,
			h: 48,
		}
	};
	InitGridData();
	
	// Item search
	identifyIndex = undefined;
	identifyDuration = TimerFromSeconds(2);
	identifyTimer = 0;
	
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
			inventory_id: inventoryId,
			items: itemArray
		}
	}
	
	static InitGridData = function()
	{
		// RESET GRID DATA
	    for (var i = 0; i < size.rows; i++) {
		  for (var j = 0; j < size.columns; j ++) {
		    gridData[i, j] = undefined;
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

    static AddItem = function(_item, _grid_index = undefined, _known = true, _ignore_network = false)
    {
		var isItemAdded = false;
		if (IsItemTypeWhiteListed(_item))
		{
			if (!is_undefined(_grid_index))
			{
				_item.grid_index = _grid_index.Clone();
			} else {
				if (_item.quantity < _item.max_stack)
				{
					if (StackItem(_item))
					{
						// ITEM IS ADDED WHEN IT FITS TO A STACK
						isItemAdded = true;
					} else {
						_item.grid_index = FindEmptyIndex(_item);
					}
				} else {
					_item.grid_index = FindEmptyIndex(_item);
				}
			}
			
			if (!isItemAdded)
			{
				if (!is_undefined(_item.grid_index))
				{
					_item.known = _known;
					_item.sourceInventory = self;
				
					FillGridArea(_item.grid_index.col, _item.grid_index.row, _item.size, new GridIndex(_item.grid_index.col, _item.grid_index.row));
			
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
			
					ds_list_add(items, _item.Clone());
					isItemAdded = true;
				} else {
					// MESSAGE LOG
					AddMessageLog(string(_item.name) + " doesn't fit!");
				}
			}
		} else {
			// MESSAGE LOG
			AddMessageLog(string(_item.name) + " type is wrong to fit!");
		}
		return isItemAdded;
    }
	
	static StackItem = function(_item, _grid_index = undefined)
	{
		var isItemStacked = false;
		var itemCount = GetItemCount();
		for (var i = 0; i < itemCount; i++)
		{
			var item = GetItemByIndex(i);
			if (item.max_stack > 1)
			{
				if (item.Compare(_item))
				{
					item.Stack(_item);
					isItemStacked = _item.quantity <= 0;
				}
			}
		}
		
		return isItemStacked;
	}
	
	static ReplaceWithRollback = function(_oldItem, _newItem)
    {
		var isItemReplaced = true;
		var oldItemClone = _oldItem.Clone();
		var oldGridIndex = _oldItem.grid_index;
		
		RemoveItemByGridIndex(oldGridIndex);
		if (!AddItem(_newItem))
		{
			// ROLLBACK IF NEW ITEM DOESN'T FIT
			AddItem(oldItemClone, oldGridIndex);
			isItemReplaced = false;
		}
		
		return isItemReplaced;
    }
	
	static SwapWithRollback = function(_sourceItem, _targetItem)
	{
		var isItemSwapped = false;
		var cloneSourceItem = _sourceItem.Clone();
		var cloneTargetItem = _targetItem.Clone();
		
		if (_targetItem.sourceInventory.ReplaceWithRollback(_targetItem, cloneSourceItem))
		{
			if (_sourceItem.sourceInventory.ReplaceWithRollback(_sourceItem, cloneTargetItem))
			{
				isItemSwapped = true;
			} else {
				cloneSourceItem.sourceInventory.RemoveItemByGridIndex(cloneSourceItem.grid_index);
				cloneTargetItem.sourceInventory.AddItem(cloneTargetItem, cloneTargetItem.grid_index, cloneTargetItem.known);
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
				
					buffer_write(networkBuffer, buffer_text , inventoryId);
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
	
	static IsItemTypeWhiteListed = function(_item)
    {
		return (array_length(filterArray) == 0) || ArrayContainsValue(filterArray, _item.type);
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
			
				buffer_write(networkBuffer, buffer_text , inventoryId);
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
				if (is_undefined(gridData[i][j]))
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
		return ((_col + _item.size.w - 1) < array_length(gridData[0]) && (_row + _item.size.h - 1) < array_length(gridData));
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
					var gridIndex = gridData[i][j];
					if (!is_undefined(gridIndex))
					{
						if (!is_undefined(_ignoreSource) && !is_undefined(_ignoreGridIndex))
						{
							if (_item.sourceInventory.inventoryId == _ignoreSource.inventoryId)
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
				gridData[i][j] = _value;
			}
		}
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
}
