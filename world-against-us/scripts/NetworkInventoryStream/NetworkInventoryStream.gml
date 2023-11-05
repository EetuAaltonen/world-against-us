function NetworkInventoryStream(_target_container_id, _target_inventory, _stream_item_limit, _is_stream_sending, _stream_end_index) constructor
{
	target_container_id = _target_container_id;
	target_inventory = _target_inventory;
	
	stream_item_limit = _stream_item_limit;
	is_stream_sending = _is_stream_sending;
	
	stream_start_index = 0;
	stream_current_index = stream_start_index;
	stream_end_index = _stream_end_index;
	
	static FetchNextItems = function()
	{
		var formatItems = [];
		if (!is_undefined(target_inventory))
		{
			var lastItemIndex = stream_current_index + stream_item_limit;
			var itemList = target_inventory.GetItemsByIndexRange(stream_current_index, lastItemIndex);
			formatItems = FormatItemListToJSONArray(itemList);
			
			stream_current_index += array_length(formatItems);
		}
		return formatItems;
	}
}