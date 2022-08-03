function GridIndex(_col, _row) constructor
{
	col = _col;
	row = _row;
	
	static Clone = function()
	{
		return new GridIndex(col, row);	
	}
}
