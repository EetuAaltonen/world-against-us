function CalculateSpriteOffsetToCenter(_sprite, _scale)
{
	var offset = new Vector2(0, 0);
	var spriteCenterPos = new Vector2(
		sprite_get_width(_sprite) * 0.5,
		sprite_get_height(_sprite) * 0.5
	);
	
	offset.X = (sprite_get_xoffset(_sprite) - spriteCenterPos.X) * _scale;
	offset.Y = (sprite_get_yoffset(_sprite) - spriteCenterPos.Y) * _scale;
	
	return offset;
}