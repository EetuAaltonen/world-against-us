function Item(_name, _short_name, _icon, _size, _category, _type, _weight, _max_stack, _base_price, _description, _quantity = 1, _metadata = undefined, _is_rotated = false, _known = true, _grid_index = undefined) constructor
{
	name = _name;
	short_name = _short_name;
	icon = _icon;
	size = _size;
	category = _category;
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
		var formatMetadata = !is_undefined(metadata) ? metadata.ToJSONStruct(metadata) : metadata;
		var formatGridIndex = grid_index.ToJSONStruct();
		return {
			name: name,
			short_name: short_name,
			quantity: quantity,
			metadata: formatMetadata,
			is_rotated: is_rotated,
			known: known,
			grid_index: formatGridIndex
		};
	}
	
	static Clone = function(_newQuantity = undefined, _ignoreSourceInventory = false)
	{
		var cloneItem = new Item(
			name, short_name, icon, size, category, type,
			weight, max_stack, base_price, description,
			_newQuantity ?? quantity,
			ParseMetadataItem(metadata, category, type),
			is_rotated, known,
			undefined
		);
		
		if (!_ignoreSourceInventory)
		{
			// RESET ROTATION
			if (cloneItem.is_rotated)
			{
				cloneItem.Rotate();	
			}
			
			// RESET SOURCE INVENTORY INFO
			cloneItem.grid_index = !is_undefined(grid_index) ? grid_index.Clone() : undefined;
			cloneItem.sourceInventory = sourceInventory;
		}
		
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
				short_name == _other.short_name &&
				icon == _other.icon &&
				category == _other.category &&
				type == _other.type &&
				known == _other.known
			);
		}
		return isIdentical;
	}
	
	static Stack = function(_sourceItem, _priorityQuantity = undefined)
	{
		if (quantity < max_stack)
		{
			var quantityToStack = min((max_stack - quantity), _sourceItem.quantity);
			quantityToStack = min(_priorityQuantity ?? quantityToStack, quantityToStack);
			if (quantityToStack > 0)
			{
				quantity += quantityToStack;
				_sourceItem.quantity -= quantityToStack;
			}
		}
	}
}
