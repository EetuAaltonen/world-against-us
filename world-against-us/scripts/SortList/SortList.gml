function SortList(sourceList, compareFunction)
{
	var sortedList = ds_list_create();
	
	while (ds_list_size(sourceList) > 0)
	{
		var sourceObject = sourceList[| 0];
		var sortedListSize = ds_list_size(sortedList);
		if (sortedListSize > 0)
		{
			for (var i = 0; i < sortedListSize; ++i)
		    {
		        var sortedObject = sortedList[| i];
		        if (compareFunction(sourceObject, sortedObject))
		        {
					ds_list_insert(sortedList, i, sourceObject);
		            break;
		        } else {
					if (i == sortedListSize - 1)
					{
						ds_list_add(sortedList, sourceObject);
					}
				}
		    }
		} else {
			ds_list_add(sortedList, sourceObject);	
		}
	    ds_list_delete(sourceList, 0);
	}
	
	ds_list_copy(sourceList, sortedList);
}