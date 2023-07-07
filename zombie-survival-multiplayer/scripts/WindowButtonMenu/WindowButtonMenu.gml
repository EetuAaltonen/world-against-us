function WindowButtonMenu(_elementId, _relativePosition, _size, _backgroundColor, _buttonsData, _buttonStyle) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	buttonsData = _buttonsData;
	buttonStyle = _buttonStyle;
	
	initButtons = true;
	
	static InitButtons = function()
	{
		initButtons = false;
		
		if (!is_undefined(buttonsData))
		{
			DeleteChildElements();
			
			var buttonElements = ds_list_create();
			var buttonCount = ds_list_size(buttonsData);
			var buttonMargin = (buttonStyle.margin + buttonStyle.size.h);
			var buttonPosition = new Vector2(0, 0);
			if (buttonStyle.button_h_align == fa_center)
			{
				buttonPosition.X -= buttonStyle.size.w * 0.5;
			} else if (buttonStyle.button_h_align == fa_right)
			{
				buttonPosition.X -= buttonStyle.size.w;
			}
			
			if (buttonStyle.button_v_align == fa_center)
			{
				buttonPosition.Y -= buttonMargin * (buttonCount * 0.5);
			} else if (buttonStyle.button_v_align == fa_bottom)
			{
				buttonPosition.Y -= buttonMargin * buttonCount;
			}
			
			for (var i = 0; i < buttonCount; i++)
			{
				var buttonData = buttonsData[| i];
				var newButton = new WindowButton(
					(elementId + buttonData.title),
					new Vector2(buttonPosition.X, buttonPosition.Y),
					buttonStyle.size, buttonStyle.button_background_color, buttonData.title, buttonStyle, buttonData.onClick, buttonData.metadata
				);
				ds_list_add(buttonElements, newButton);
				buttonPosition.Y += buttonMargin;
			}
			AddChildElements(buttonElements);
		}
	}
	
	static UpdateContent = function()
	{
		if (initButtons)
		{
			InitButtons();
		}
		
		UpdateChildElements();
	}
	
	static DrawContent = function()
	{
		if (!initButtons)
		{
			var buttonCount = ds_list_size(childElements);
			for (var i = 0; i < buttonCount; i++)
			{
				var button = childElements[| i];
				button.Draw();
			}
		}
	}
}