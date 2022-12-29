function GridIndex(_col, _row) constructor
{
	col = _col;
	row = _row;
	
	static ToJSONStruct = function()
	{
		return {
			col: col,
			row: row
		}
	}
	
	static Clone = function()
	{
		return new GridIndex(col, row);	
	}
	
	static Compare = function(_other)
	{
		return (col == _other.col && row == _other.row);	
	}
}
