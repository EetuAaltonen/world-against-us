function Item(_name, _icon, _size, _type, _weight, _max_stack, _base_price, _descripton, _quantity = 1, _metadata = noone, _rotated = false, _known = true, _source_type = noone, _grid_index = noone) constructor
{
	name = _name;
	icon = _icon;
	size = _size;
	type = _type;
	weight = _weight;
	max_stack = _max_stack;
	base_price = _base_price;
	description = _descripton;
	quantity = _quantity;
	metadata = _metadata;
	
	rotated = _rotated;
	known = _known;
	source_type = _source_type;
	grid_index = _grid_index;
	
	
	static Clone = function(_newQuantity = undefined)
	{
		return new Item(
			name, icon, size, type, weight, max_stack, base_price, description,
			_newQuantity ?? quantity,
			metadata, rotated, known, source_type,
			(grid_index != noone) ? new GridIndex(grid_index.col, grid_index.row) : grid_index
		);
	}
	
	static Rotate = function()
	{
		if (size.w != size.h)
		{
			rotated = !rotated;
			// Swap width and height
			size = new Size(size.h, size.w);
		}
	}
	
	static Compare = function(_other)
	{
		return (
			name == _other.name &&
			icon == _other.icon &&
			type == _other.type
		);
	}
}
