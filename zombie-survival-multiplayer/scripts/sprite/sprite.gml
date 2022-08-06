function ScaleSpriteToFitSize(_sprite, _maxWidth, _maxHeight) {
	var spriteWidth = sprite_get_width(_sprite);
	var spriteHeight = sprite_get_height(_sprite);
	
	return (spriteWidth >= spriteHeight) ? (_maxWidth / spriteWidth) : (_maxHeight / spriteHeight);
}