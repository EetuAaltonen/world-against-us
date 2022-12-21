function Inventory(_inventoryId, _type, _size = { columns: 10, rows: 10 }, _filterArray = []) constructor
{
	inventoryId = _inventoryId
    items = ds_list_create();
	type = _type;
	size = _size;
	filterArray = _filterArray;
	
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
	
	// Item search
	identifyIndex = undefined;
	identifyDuration = TimerFromSeconds(2);
	identifyTimer = 0;
	
	static GetItemCount = function()
    {
		return ds_list_size(items);
    }

    static AddItem = function(_item, _grid_index = noone, _known = true, _ignore_network = false)
    {
		var isItemAdded = false;
        _item.grid_index = (_grid_index != noone) ? new GridIndex(_grid_index.col, _grid_index.row) : FindEmptyIndex(_item);
		_item.known = _known;
		
		if (IsItemTypeWhiteListed(_item))
		{
			if (_item.grid_index != noone)
			{
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
		} else {
			// MESSAGE LOG
			AddMessageLog(string(_item.name) + " type is wrong to fit!");
		}
		return isItemAdded;
    }
	
	static ReplaceWithRollback = function(_oldItem, _newItem)
    {
		var isItemReplaced = true;
		var oldItemClone = _oldItem.Clone();
		
		RemoveItemByGridIndex(_oldItem.grid_index);
		if (!AddItem(_newItem))
		{
			// ROLLBACK IF NEW ITEM DOESN'T FIT
			AddItem(oldItemClone);
			isItemReplaced = false;
		}
		
		return isItemReplaced;
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
		var originalRotation = item.isRotated;
		
		if (!is_undefined(item))
		{
			// Clear previous spot
			FillGridArea(item.grid_index.col, item.grid_index.row, item.size, noone);
			
			// Set rotation
			if (_isRotated != item.isRotated)
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
					show_debug_message(string(item.isRotated));
				
					buffer_write(networkBuffer, buffer_text , inventoryId);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.col);
					buffer_write(networkBuffer, buffer_u16, _newGridIndex.row);
					buffer_write(networkBuffer, buffer_bool, item.isRotated);
					buffer_write(networkBuffer, buffer_text, jsonData);
					global.ObjNetwork.client.SendPacketOverUDP(networkBuffer);
				}
				
				item.grid_index = _newGridIndex;
			} else {
				// Reverse rotation if item doesn't fit
			    if (item.isRotated != originalRotation) {
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
	
	static RemoveItem = function(_index)
    {
		var item = GetItemByIndex(_index);
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
			var item = GetItemByIndex(i);
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
					if (gridIndex != noone)
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
