function InventorySize(_columns, _rows) constructor
{
	columns = _columns;
	rows = _rows;
	
	static ToJSONStruct = function()
	{
		return {
			columns: columns,
			rows: rows
		};
	}
	
	static OnDestroy = function(_struct = self)
	{
		// NO GARBAGE CLEANING
	}
	
	static Clone = function()
	{
		return new InventorySize(
			columns,
			rows
		);
	}
}