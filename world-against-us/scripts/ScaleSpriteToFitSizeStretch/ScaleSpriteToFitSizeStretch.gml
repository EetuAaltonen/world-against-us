function ScaleSpriteToFitSizeStretch(_sprite, _maxSize) {
	var spriteWidth = sprite_get_width(_sprite);
	var spriteHeight = sprite_get_height(_sprite);
	var widthRatio = (is_undefined(_maxSize.w)) ? MAX_SPRITE_SIZE : (_maxSize.w / spriteWidth);
	var heightRatio = (is_undefined(_maxSize.h)) ? MAX_SPRITE_SIZE : (_maxSize.h / spriteHeight);
	
	return new Vector2(widthRatio, heightRatio);
}