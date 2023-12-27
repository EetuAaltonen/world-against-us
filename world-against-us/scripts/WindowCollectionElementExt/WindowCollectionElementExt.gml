function WindowCollectionElementExt(_elementId, _relativePosition, _size, _backgroundColor, _elementData, _drawFunction, _elementStyle, _isInteractive, _callbackFunction = undefined) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	elementData = _elementData;
	drawFunction = _drawFunction;
	elementStyle = _elementStyle;
	isInteractive = _isInteractive;
	callbackFunction = _callbackFunction;
	
	static CheckInteraction = function()
	{
		if (isInteractive)
		{
			if (isHovered)
			{
				if (mouse_check_button_released(mb_left))
				{
					if (!is_undefined(callbackFunction))
					{
						callbackFunction(elementData);
					}
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		drawFunction(position, size, elementData, elementStyle);
	}
}