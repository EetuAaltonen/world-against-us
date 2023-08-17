function WindowActionMenu(_elementId, _relativePosition, _size, _backgroundColor, _buttonsData, _buttonStyle, _targetItem) : WindowButtonMenu(_elementId, _relativePosition, _size, _backgroundColor, _buttonsData, _buttonStyle) constructor
{
	targetItem = _targetItem;
	
	static CheckInteraction = function()
	{
		if (!isHovered)
		{
			if (mouse_check_button_released(mb_left) || mouse_check_button_released(mb_right))
			{
				global.GUIStateHandlerRef.CloseCurrentGUIState();
			}
		}
	}
}