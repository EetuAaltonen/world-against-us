// Inherit the parent event
event_inherited();

if (facility.inventory.GetItemCount() <= 0)
{
	if (!is_undefined(global.ItemData))
	{
		var itemIndices = ds_map_keys_to_array(global.ItemData);
		var ignoreItemFunction = function(_element, _index)
		{
			var ignoreItems = ["Money"];
		    return !ArrayContainsValue(ignoreItems, _element);
		}
		array_filter_ext(itemIndices, ignoreItemFunction);
		
		var itemCount = array_length(itemIndices);
		while(true)
		{
			var randomItemIndex = itemIndices[@ irandom_range(0, (itemCount - 1))];
			var item = global.ItemData[? randomItemIndex];
			if (!facility.inventory.AddItem(item.Clone(), undefined, true)) break;
		}
		
		// DISABLE ITEM INPUT
		facility.inventory.filterArray = ["OutputOnly"];
	}
}