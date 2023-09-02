function MapData() constructor
{
	entries = ds_list_create();
	
	static ToJSONStruct = function()
	{
		var formatMapEntries = [];
		var mapDataEntryCount = ds_list_size(entries);
		for (var i = 0; i < mapDataEntryCount; i++)
		{
			var mapEntry = entries[| i];
			array_push(formatMapEntries, mapEntry.ToJSONStruct());
		}
		
		return {
			entries: formatMapEntries
		}
	}
	
	static AddEntry = function(_mapDataEntry)
	{
		ds_list_add(entries, _mapDataEntry);
	}
	
	static GetEntryByIndex = function(_index)
	{
		return entries[| _index];
	}
	
	static GetEntryCount = function()
	{
		return ds_list_size(entries);
	}
	
	static Clear = function(_mapDataEntry)
	{
		ds_list_clear(entries);
	}
}