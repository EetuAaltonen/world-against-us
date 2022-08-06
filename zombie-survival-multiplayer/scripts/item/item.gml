function Item(_name, _icon, _size, _type, _weight, _descripton, _metadata = noone, _rotated = false, _known = true, _sourceType = noone, _gridIndex = noone) constructor
{
	name = _name;
	icon = _icon;
	size = _size;
	type = _type;
	weight = _weight;
	description = _descripton;
	metadata = _metadata;
	
	rotated = _rotated;
	known = _known;
	sourceType = _sourceType;
	gridIndex = _gridIndex;
	
	
	static Clone = function()
	{
		return new Item(
			name, icon, size, type, weight, description,
			metadata, rotated, known, sourceType,
			(gridIndex != noone) ? gridIndex.Clone() : gridIndex
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
}
