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
	
	static Clone = function()
	{
		return new InventorySize(
			columns,
			rows
		);
	}
}