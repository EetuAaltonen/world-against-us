function WindowList(_elementId, _position, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction = undefined) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	listData = _listData;
	drawFunction = _drawFunction;
	isInteractive = _isInteractive;
	callbackFunction = _callbackFunction;
	
	initListElements = true;
	
	static UpdateContent = function()
	{
		if (initListElements)
		{
			initListElements = false;
			
			var listElements = ds_list_create();
			var listElementSize = new Size(size.w, 60);
			var listElementMargin = listElementSize.h;
			var listElementPosition = new Vector2(0, 0);
			
			var listElementCount = ds_list_size(listData);
			for (var i = 0; i < listElementCount; i++)
			{
				var elementData = listData[| i];
				var newListElement = new WindowListElement(
					elementId + string(i),
					new Vector2(listElementPosition.X, listElementPosition.Y),
					listElementSize, undefined, elementData,
					drawFunction, isInteractive, callbackFunction
				);
				ds_list_add(listElements, newListElement);
				listElementPosition.Y += listElementMargin;
			}
			AddChildElements(listElements);
		} else {
			UpdateChildElements();
		}
	}
	
	static DrawContent = function()
	{
		if (!initListElements)
		{
			var listElementCount = ds_list_size(childElements);
			for (var i = 0; i < listElementCount; i++)
			{
				var listElement = childElements[| i];
				listElement.Draw();
			}
		}
	}
}