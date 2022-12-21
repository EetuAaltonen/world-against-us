function Item(_name, _icon, _size, _type, _weight, _max_stack, _base_price, _descripton, _quantity = 1, _metadata = noone, _isRotated = false, _known = true, _grid_index = noone) constructor
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
	
	isRotated = _isRotated;
	known = _known;
	sourceInventory = undefined;
	grid_index = _grid_index;
	
	
	static Clone = function(_newQuantity = undefined)
	{
		var cloneItem = new Item(
			name, icon, size, type,
			weight, max_stack, base_price, description,
			_newQuantity ?? quantity,
			CloneStruct(metadata),
			isRotated, known,
			(grid_index != noone) ? new GridIndex(grid_index.col, grid_index.row) : grid_index
		);
		cloneItem.sourceInventory = sourceInventory;
		
		return cloneItem;
	}
	
	static Rotate = function()
	{
		if (size.w != size.h)
		{
			isRotated = !isRotated;
			// Swap width and height
			size = SwapSize(size);
		}
	}
	
	static Compare = function(_other)
	{
		var isIdentical = false;
		if (!is_undefined(_other))
		{
			isIdentical = (
				name == _other.name &&
				icon == _other.icon &&
				type == _other.type
			);
		}
		return isIdentical;
	}
}
