function WindowAnimation(_elementId, _relativePosition, _size, _backgroundColor, _spriteIndex, _imageIndex, _imageAlpha, _rotation, _animationSpeed) : WindowImage(_elementId, _relativePosition, _size, _backgroundColor, _spriteIndex, _imageIndex, _imageAlpha, _rotation) constructor
{
	animationSpeed = _animationSpeed;
	
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
		
		var spriteCount = sprite_get_number(spriteIndex);
		imageIndex += animationSpeed;
		if (floor(imageIndex) > spriteCount) { imageIndex = 0; }
	}
}