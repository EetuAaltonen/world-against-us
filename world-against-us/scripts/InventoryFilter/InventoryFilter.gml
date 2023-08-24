function InventoryFilter(_whitelisted_names, _whitelisted_categories, _whitelisted_types) constructor
{
	whitelisted_names = _whitelisted_names;
	whitelisted_categories = _whitelisted_categories;
	whitelisted_types = _whitelisted_types;
	
	static ToJSONStruct = function()
	{
		return {
			whitelisted_names: whitelisted_names,
			whitelisted_categories: whitelisted_categories,
			whitelisted_types: whitelisted_types,
		};
	}
	
	static IsItemWhitelisted = function(_item)
	{
		var isItemWhitelisted = false;
		
		var whitelistedNameCount = array_length(whitelisted_names);
		var whitelistedCategoryCount = array_length(whitelisted_categories);
		var whitelistedTypeCount = array_length(whitelisted_types);
		
		if (whitelistedNameCount == 0 && whitelistedCategoryCount == 0 && whitelistedTypeCount == 0)
		{
			isItemWhitelisted = true;
		} else {
			if (whitelistedNameCount > 0)
			{
				if (ArrayContainsValue(whitelisted_names, _item.name)) isItemWhitelisted = true;
			}
		
			if (whitelistedCategoryCount > 0)
			{
				if (ArrayContainsValue(whitelisted_categories, _item.category)) isItemWhitelisted = true;
			}
		
			if (whitelistedTypeCount > 0)
			{
				if (ArrayContainsValue(whitelisted_types, _item.type)) isItemWhitelisted = true;
			}
		}
		
		return isItemWhitelisted;
	}
}