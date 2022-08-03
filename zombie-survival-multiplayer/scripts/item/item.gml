function Item(_name, _icon, _size, _weight, _descripton, _iconXScale = 1, _iconYScale = 1, _gridIndex = noone) constructor
{
	name = _name;
	icon = _icon;
	iconXScale = _iconXScale;
	iconYScale = _iconYScale;
	gridIndex = _gridIndex;
	size = _size;
	weight = _weight;
	description = _descripton;
	
	static UpdateIconScale = function(_grid)
	{
		var spriteWidth = sprite_get_width(icon);
		var spriteHeight = sprite_get_height(icon);
		while ((spriteWidth * iconXScale < (_grid.size.w * 0.85) * size.w) &&
				(spriteHeight * iconYScale < (_grid.size.h * 0.85) * size.h))
		{
			iconXScale += 0.1;
			iconYScale += 0.1;
		}
	}
	
	static Clone = function()
	{
		return new Item(
			name, icon, size, weight, description,
			iconXScale, iconYScale, gridIndex
		);
	}
}
