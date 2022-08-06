function JSONStructToItem(_jsonStruct) {
	return new Item(
		_jsonStruct[$ "name"],
		asset_get_index(_jsonStruct[$ "icon"]),
		new Size(
			_jsonStruct[$ "size"].w,
			_jsonStruct[$ "size"].h
		),
		_jsonStruct[$ "type"],
		_jsonStruct[$ "weight"],
		_jsonStruct[$ "description"],
		_jsonStruct[$ "metadata"]
	);
}