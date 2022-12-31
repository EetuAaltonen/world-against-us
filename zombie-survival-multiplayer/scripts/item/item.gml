function Item(_name, _icon, _size, _type, _weight, _max_stack, _base_price, _description, _quantity = 1, _metadata = undefined, _is_rotated = false, _known = true, _grid_index = undefined) constructor
{
	name = _name;
	icon = _icon;
	size = _size;
	type = _type;
	weight = _weight;
	max_stack = _max_stack;
	base_price = _base_price;
	description = _description;
	quantity = _quantity;
	metadata = _metadata;
	
	is_rotated = _is_rotated;
	known = _known;
	sourceInventory = undefined;
	grid_index = _grid_index;
	
	static ToJSONStruct = function()
	{
		var formatIcon = sprite_get_name(icon);
		var formatSize = size.ToJSONStruct();
		var formatMetadata = !is_undefined(metadata) ? metadata.ToJSONStruct(metadata) : metadata;
		var formatGridIndex = grid_index.ToJSONStruct();
		
		return {
			name: name,
			icon: formatIcon,
			size: formatSize,
			type: type,
			weight: weight,
			max_stack: max_stack,
			base_price: base_price,
			description: description,
			quantity: quantity,
			metadata: formatMetadata,
	
			is_rotated: is_rotated,
			known: known,
			grid_index: formatGridIndex
		}
	}
	
	static Clone = function(_newQuantity = undefined)
	{
		var cloneItem = new Item(
			name, icon, size, type,
			weight, max_stack, base_price, description,
			_newQuantity ?? quantity,
			ParseItemMetadata(metadata, type),
			is_rotated, known,
			!is_undefined(grid_index) ? new GridIndex(grid_index.col, grid_index.row) : grid_index
		);
		cloneItem.sourceInventory = sourceInventory;
		
		return cloneItem;
	}
	
	static Rotate = function()
	{
		if (size.w != size.h)
		{
			is_rotated = !is_rotated;
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
