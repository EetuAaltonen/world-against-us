// INHERIT THE PARENT EVENT
event_inherited();

if (facility.inventory.GetItemCount() <= 0)
{
	if (!is_undefined(global.ItemDatabase))
	{
		var itemIndices = global.ItemDatabase.GetItemNames();
		var ignoreItemFunction = function(_element, _index)
		{
			var ignoreItems = ["Money"];
		    return !ArrayContainsValue(ignoreItems, _element);
		}
		array_filter_ext(itemIndices, ignoreItemFunction);
		
		var itemCount = array_length(itemIndices);
		while(true)
		{
			var randomItemName = itemIndices[@ irandom_range(0, (itemCount - 1))];
			var item = global.ItemDatabase.GetItemByName(randomItemName);
			var addedItemGridIndex = facility.inventory.AddItem(item.Clone(), undefined, true);
			if (is_undefined(addedItemGridIndex)) break;
		}
		
		// DISABLE ITEM INPUT
		facility.inventory.filter_array = ["OutputOnly"];
	}
}