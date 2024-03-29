function Item(_name, _short_name, _icon, _size, _category, _type, _weight, _max_stack, _base_price, _description, _quantity = 1, _metadata = undefined, _is_rotated = false, _is_known = true, _grid_index = undefined) constructor
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
	is_known = _is_known;
	sourceInventory = undefined;
	grid_index = _grid_index;
	
	static ToJSONStruct = function()
	{
		var formatMetadata = (!is_undefined(metadata)) ? metadata.ToJSONStruct(metadata) : metadata;
		var formatGridIndex = (!is_undefined(grid_index)) ? grid_index.ToJSONStruct() : grid_index;
		return {
			name: name,
			quantity: quantity,
			metadata: formatMetadata,
			is_rotated: is_rotated,
			is_known: is_known,
			grid_index: formatGridIndex
		};
	}
	
	static Clone = function(_newQuantity = undefined)
	{
		var parsedMetadata = (!is_undefined(metadata)) ? ParseJSONStructToMetadataItem(metadata, category, type) : undefined;
		var cloneSize = !is_undefined(size) ? size.Clone() : undefined;
		var cloneItem = new Item(
			name, short_name, icon, cloneSize, category, type,
			weight, max_stack, base_price, description,
			_newQuantity ?? quantity,
			parsedMetadata,
			is_rotated, is_known,
			undefined
		);
		
		return cloneItem;
	}
	
	static OnDestroy = function()
	{
		if (!is_undefined(metadata))
		{
			if (is_struct(metadata))
			{
				if (struct_exists(metadata, "OnDestroy"))
				{
					metadata.OnDestroy();
				}
				metadata = undefined;
			}
		}
	}
	
	static Rotate = function()
	{
		var isRotationToggled = false;
		if (size.w != size.h)
		{
			is_rotated = !is_rotated;
			size.Swap();
			isRotationToggled = true;
		}
		return isRotationToggled;
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
				is_known == _other.is_known
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