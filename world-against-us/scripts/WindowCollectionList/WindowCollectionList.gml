function WindowCollectionList(_elementId, _relativePosition, _size, _backgroundColor, _dataCollection, _drawFunction, _isInteractive, _callbackFunction = undefined) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	dataCollection = _dataCollection;
	drawFunction = _drawFunction;
	isInteractive = _isInteractive;
	callbackFunction = _callbackFunction;
	
	initDataElements = true;
	
	static UpdateDataCollection = function(newDataCollection)
	{
		dataCollection = newDataCollection;
		initDataElements = true;
	}
	
	static UpdateContent = function()
	{
		if (initDataElements)
		{
			initDataElements = false;
			// CLEAR CHILD ELEMENTS
			ClearDSListAndDeleteValues(childElements);
			
			var listElements = ds_list_create();
			// TODO: Ability to change list element size
			var listElementSize = new Size(size.w, 60);
			var listElementMargin = listElementSize.h;
			var listElementPosition = new Vector2(0, 0);
			
			var listElementCount = ds_list_size(dataCollection);
			for (var i = 0; i < listElementCount; i++)
			{
				var elementData = dataCollection[| i];
				var newListElement = new WindowCollectionElement(
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
		if (!initDataElements)
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