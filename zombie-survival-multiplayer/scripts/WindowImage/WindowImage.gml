function WindowImage(_elementId, _relativePosition, _size, _backgroundColor, _spriteIndex, _imageIndex = 0, _imageAlpha = 1) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	spriteIndex = _spriteIndex;
	imageIndex = _imageIndex;
	imageAlpha = _imageAlpha;
	
	initImage = true;
	imageScale = 1;
	imagePosition = new Vector2(0, 0);
	
	static UpdateContent = function()
	{
		if (initImage)
		{
			initImage = false;
			if (!is_undefined(spriteIndex))
			{
				if (!sprite_exists(spriteIndex)) { spriteIndex = sprMissingSprite; }
				InitImageScale();
			}
		}
	}
	
	static InitImageScale = function()
	{
		var spriteSize = new Size(sprite_get_width(spriteIndex), sprite_get_height(spriteIndex));
		var imageWidthRatio = (size.w / spriteSize.w);
		var imageHeightRatio = (size.h / spriteSize.h);
		
		imagePosition = new Vector2(0, 0);
		if (imageWidthRatio < imageHeightRatio)
		{
			imageScale = imageWidthRatio;
			imagePosition.Y = (size.h * 0.5) - (spriteSize.h * 0.5 * imageScale);
		} else {
			imageScale = imageHeightRatio;
			imagePosition.X = (size.w * 0.5) - (spriteSize.w * 0.5 * imageScale);
		}
		imagePosition.X += (sprite_get_xoffset(spriteIndex) * imageScale);
		imagePosition.Y += (sprite_get_yoffset(spriteIndex) * imageScale);
	}
	
	static DrawContent = function()
	{
		if (!is_undefined(spriteIndex))
		{
			if (sprite_exists(spriteIndex))
			{
				draw_sprite_ext(spriteIndex, imageIndex, position.X + imagePosition.X, position.Y + imagePosition.Y, imageScale, imageScale, 0, c_white, imageAlpha);
			} else {
				draw_sprite_ext(sprGUIBg, 0, position.X, position.Y, size.w, size.h, 0, #fc03e7, 1);	
			}
		}
	}
}