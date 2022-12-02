function WindowPanel(_elementId, _position, _size, _backgroundColor) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{	
	static UpdateContent = function()
	{
		UpdateChildElements();
	}
	
	static DrawContent = function()
	{
		var elementCount = ds_list_size(childElements);
		for (var i = 0; i < elementCount; i++)
		{
			var childElement = childElements[| i];
			childElement.Draw();
		}
	}
}