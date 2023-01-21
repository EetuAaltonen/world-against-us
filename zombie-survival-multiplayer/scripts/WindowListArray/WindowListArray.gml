function WindowListArray(_elementId, _relativePosition, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction = undefined) : WindowList(_elementId, _relativePosition, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction) constructor
{
	static UpdateContent = function()
	{
		if (initListElements)
		{
			initListElements = false;
			// CLEAR CHILD ELEMENTS
			ds_list_clear(childElements);
			
			var arrayElements = ds_list_create();
			var arrayElementSize = new Size(size.w, 60);
			var arrayElementMargin = arrayElementSize.h;
			var arrayElementPosition = new Vector2(0, 0);
			
			var arrayElementCount = array_length(listData);
			for (var i = 0; i < arrayElementCount; i++)
			{
				var elementData = listData[@ i];
				var newListElement = new WindowListElement(
					elementId + string(i),
					new Vector2(arrayElementPosition.X, arrayElementPosition.Y),
					arrayElementSize, undefined, elementData,
					drawFunction, isInteractive, callbackFunction
				);
				ds_list_add(arrayElements, newListElement);
				arrayElementPosition.Y += arrayElementMargin;
			}
			AddChildElements(arrayElements);
		} else {
			UpdateChildElements();
		}
	}
}