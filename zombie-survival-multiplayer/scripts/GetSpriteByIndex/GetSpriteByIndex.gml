function GetSpriteByIndex(_spriteIndex)
{
	var spriteIndex = sprMissingSprite;
	if (is_string(_spriteIndex)) { _spriteIndex = asset_get_index(_spriteIndex); }
	if (sprite_exists(_spriteIndex)) { spriteIndex = _spriteIndex; }
	return spriteIndex;
}