function ScaleSpriteToFitSize(_sprite, _maxSize) {
	var spriteWidth = sprite_get_width(_sprite);
	var spriteHeight = sprite_get_height(_sprite);
	var widthRatio = (is_undefined(_maxSize.w)) ? infinity : (_maxSize.w / spriteWidth);
	var heightRatio = (is_undefined(_maxSize.h)) ? infinity : (_maxSize.h / spriteHeight);
	
	return min(widthRatio, heightRatio);
}