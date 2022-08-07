function ScaleSpriteToFitSize(_sprite, _maxWidth, _maxHeight) {
	var spriteWidth = sprite_get_width(_sprite);
	var spriteHeight = sprite_get_height(_sprite);
	var widthRatio = (is_undefined(_maxWidth)) ? infinity : (_maxWidth / spriteWidth);
	var heightRatio = (is_undefined(_maxHeight)) ? infinity : (_maxHeight / spriteHeight);
	
	return min(widthRatio, heightRatio);
}

function GetBulletSpriteFromCaliber(_caliber)
{
	var bulletSprite = undefined;
	
	if (!is_undefined(global.BulletData))
	{
		// GET VALUE BY KEY OR THE FIRST DEFAULT ELEMENT IF UNDEFINED
		bulletSprite = global.BulletData[? _caliber] ?? global.BulletData[? ds_map_find_first(global.BulletData)];
	}
	return bulletSprite;
}