function WindowCollectionMap(_elementId, _relativePosition, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction = undefined) : WindowCollectionList(_elementId, _relativePosition, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction) constructor
{
	static UpdateContent = function()
	{
		if (initDataElements)
		{
			initDataElements = false;
			// CLEAR CHILD ELEMENTS
			ClearDSListAndDeleteValues(childElements);
			
			var mapElements = ds_list_create();
			var mapElementSize = new Size(size.w, 60);
			var mapElementMargin = mapElementSize.h;
			var mapElementPosition = new Vector2(0, 0);
			
			var mapElementIndices = ds_map_keys_to_array(dataCollection);
			var mapElementCount = array_length(mapElementIndices);
			for (var i = 0; i < mapElementCount; i++)
			{
				var elementData = dataCollection[? mapElementIndices[@ i]];
				var newListElement = new WindowCollectionElement(
					elementId + string(i),
					new Vector2(mapElementPosition.X, mapElementPosition.Y),
					mapElementSize, undefined, elementData,
					drawFunction, isInteractive, callbackFunction
				);
				ds_list_add(mapElements, newListElement);
				mapElementPosition.Y += mapElementMargin;
			}
			AddChildElements(mapElements);
		} else {
			UpdateChildElements();
		}
	}
}