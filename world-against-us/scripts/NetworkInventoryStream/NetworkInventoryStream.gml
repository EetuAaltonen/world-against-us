function NetworkInventoryStream(_target_container_id, _target_instance_position, _target_inventory, _stream_item_limit, _is_stream_sending, _stream_end_index) constructor
{
	target_container_id = _target_container_id;
	target_instance_position = _target_instance_position;
	target_inventory = _target_inventory;
	
	stream_item_limit = _stream_item_limit;
	is_stream_sending = _is_stream_sending;
	
	stream_start_index = 0;
	stream_current_index = stream_start_index;
	stream_end_index = _stream_end_index;
	
	static FetchItemsToStream = function()
	{
		var items = [];
		if (!is_undefined(target_inventory))
		{
			var lastItemIndex = stream_current_index + stream_item_limit;
			var itemsList = target_inventory.GetItemsByIndexRange(stream_current_index, lastItemIndex);
			var itemCount = ds_list_size(itemsList);
			
			for (var i = 0; i < itemCount; i++)
			{
				var item = itemsList[| i];
				if (!is_undefined(item))
				{
					array_push(items, item.ToJSONStruct());
				}
			}
			
			stream_current_index += array_length(items);
		}
		return items;
	}
}