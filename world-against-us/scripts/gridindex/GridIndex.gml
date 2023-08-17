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
	
	static IsSmaller = function(_other)
	{
		var isSmaller = false;
		
		if (row <= _other.row)
		{
			if (row == _other.row)
			{
				if (col < _other.col)
				{
					isSmaller = true;
				}
			} else {
				isSmaller = true;
			}
		}
		
		return isSmaller;
	}
}
