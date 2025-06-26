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
	
	static Clone = function()
	{
		var cloneWhitelistedNames = [];
		array_copy(cloneWhitelistedNames, 0, whitelisted_names, 0, array_length(whitelisted_names));
		var cloneWhitelistedCategories = [];
		array_copy(cloneWhitelistedCategories, 0, whitelisted_categories, 0, array_length(whitelisted_categories));
		var cloneWhitelistedTypes = [];
		array_copy(cloneWhitelistedTypes, 0, whitelisted_types, 0, array_length(whitelisted_types));
		return new InventoryFilter(
			cloneWhitelistedNames,
			cloneWhitelistedCategories,
			cloneWhitelistedTypes
		);
	}
	
	static OnDestroy = function(_struct = self)
	{
		ReleaseVariableFromMemory(_struct.whitelisted_names)
		_struct.whitelisted_names = undefined;
		ReleaseVariableFromMemory(_struct.whitelisted_categories)
		_struct.whitelisted_categories = undefined;
		ReleaseVariableFromMemory(_struct.whitelisted_types)
		_struct.whitelisted_types = undefined;
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