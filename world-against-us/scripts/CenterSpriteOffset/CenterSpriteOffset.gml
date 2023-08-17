function CenterSpriteOffset(_sprite, _spriteScale = 1)
{
	return new Vector2(
		(sprite_get_xoffset(_sprite) - (sprite_get_width(_sprite) * 0.5)) * _spriteScale,
		(sprite_get_yoffset(_sprite) - (sprite_get_height(_sprite) * 0.5)) * _spriteScale
	);
}