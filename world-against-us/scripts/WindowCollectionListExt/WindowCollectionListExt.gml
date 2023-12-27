function WindowCollectionListExt(_elementId, _relativePosition, _size, _backgroundColor, _dataCollection, _drawFunction, _collectionElementStyle, _isInteractive, _callbackFunction = undefined) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	dataCollection = _dataCollection;
	drawFunction = _drawFunction;
	collectionElementStyle = _collectionElementStyle;
	isInteractive = _isInteractive;
	callbackFunction = _callbackFunction;
	
	initDataElements = true;
	
	static OnDestroy = function()
	{
		DestroyDSListAndDeleteValues(childElements);
		childElements = undefined;
		
		DestroyDSListAndDeleteValues(dataCollection);
		dataCollection = undefined;
	}
	
	static UpdateDataCollection = function(newDataCollection)
	{
		// DESTROY PREV DATA COLLECTION DS LIST
		DestroyDSListAndDeleteValues(dataCollection);
		
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
			var listElementSize = collectionElementStyle.size;
			var listElementMargin = listElementSize.h + collectionElementStyle.margin;
			var listElementPosition = new Vector2(0, 0);
			
			var listElementCount = ds_list_size(dataCollection);
			for (var i = 0; i < listElementCount; i++)
			{
				var elementData = dataCollection[| i];
				var newListElement = new WindowCollectionElementExt(
					elementId + string(i),
					listElementPosition.Clone(),
					collectionElementStyle.size, undefined, elementData,
					drawFunction, collectionElementStyle, isInteractive, callbackFunction
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