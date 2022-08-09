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
		_jsonStruct[$ "max_stack"],
		_jsonStruct[$ "base_price"],
		_jsonStruct[$ "description"],
		1, // DEFAULT QUANTITY TO 1
		_jsonStruct[$ "metadata"]
	);
}