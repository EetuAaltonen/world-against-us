function WindowListMap(_elementId, _position, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction = undefined) : WindowList(_elementId, _position, _size, _backgroundColor, _listData, _drawFunction, _isInteractive, _callbackFunction) constructor
{
	static UpdateContent = function()
	{
		if (initListElements)
		{
			initListElements = false;
			
			var mapElements = ds_list_create();
			var mapElementSize = new Size(size.w, 60);
			var mapElementMargin = mapElementSize.h;
			var mapElementPosition = new Vector2(0, 0);
			
			var mapElementIndices = ds_map_keys_to_array(listData);
			var mapElementCount = array_length(mapElementIndices);
			for (var i = 0; i < mapElementCount; i++)
			{
				var elementData = listData[? mapElementIndices[@ i]];
				var newListElement = new WindowListElement(
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