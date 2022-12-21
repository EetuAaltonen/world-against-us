function WindowHealthBar(_elementId, _position, _size, _sourceCharacter, _bodyPartIndex, _backgroundColor, _healthBarColor, _titleColor, _textColor) : WindowElement(_elementId, _position, _size, _backgroundColor) constructor
{
	sourceCharacter = _sourceCharacter;
	bodyPartIndex = _bodyPartIndex;
	sourceBodyPart = undefined;
	
	healthBarColor = _healthBarColor;
	titleColor = _titleColor;
	textColor = _textColor;
	
	static UpdateContent = function()
	{
		if (is_undefined(sourceBodyPart))
		{
			sourceBodyPart = sourceCharacter.bodyParts[? bodyPartIndex];
		}
	}
	
	static CheckInteraction = function()
	{
		if (mouse_check_button_released(mb_left))
		{
			if (isHovered)
			{
				if (!is_undefined(global.ObjMouse.dragItem))
				{
					if (global.ObjMouse.dragItem.type == "Medicine")
					{
						if (!is_undefined(sourceBodyPart))
						{
							var medicine = global.ObjMouse.dragItem.sourceInventory.GetItemByGridIndex(global.ObjMouse.dragItem.grid_index);
							sourceCharacter.UseMedicine(medicine, bodyPartIndex);
						}
						global.ObjMouse.dragItem = undefined;
					}
				}
			}
		}
	}
	
	static DrawContent = function()
	{
		if (!is_undefined(sourceBodyPart))
		{
			// PROGRESS BAR
			var healthPercent = (sourceBodyPart.condition / sourceBodyPart.maxCondition);
			var margin = 1;
			if (healthPercent > 0)
			{
				var healthBarSize = new Size(size.w * healthPercent - (margin * 2), size.h - (margin * 2));
				draw_sprite_ext(sprGUIBg, 0, position.X + margin, position.Y + margin, healthBarSize.w, healthBarSize.h, 0, healthBarColor, 1);
			}
		
			// TITLE
			draw_set_font(font_small_bold);
			draw_set_color(isHovered ? #00d921 : titleColor);
		
			draw_text(position.X, position.Y - 16, string(sourceBodyPart.name));
		
			// CONDITION
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_set_color(textColor);
		
			var valueFormatText = string("{0} / {1}", sourceBodyPart.condition, sourceBodyPart.maxCondition);
			draw_text(position.X + (size.w * 0.5), position.Y + (size.h * 0.5) + margin, valueFormatText);
		
			// RESET DRAW PROPERTIES
			ResetDrawProperties();
		}
	}
}