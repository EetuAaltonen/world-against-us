function DrawItem(_item, _imageIndex, _iconBaseScale, _imageAlpha, _position, _size, _drawFlags = [])
{
	var DrawItemAltText = function(_altText, _guiXPos, _guiYPos)
	{
		draw_set_font(font_tiny_bold);
		draw_text(_guiXPos, _guiYPos, string(_altText));
		draw_set_font(font_default);
	}
	
	// CHECK ITEM ROTATION WHEN CALCULATING ICON SCALE
	var iconScale = ScaleSpriteToFitSize(
		_item.icon, new Size(
			(_item.is_rotated ? _size.h : _size.w) * _iconBaseScale,
			(_item.is_rotated ? _size.w : _size.h) * _iconBaseScale
		)
	);
	var iconRotation = CalculateItemIconRotation(_item.is_rotated);
	var iconOffset = CalculateSpriteOffsetToCenter(_item.icon, iconScale);
	if (_item.is_rotated)
	{
		// TWEAK OFFSET IF ITEM IS ROTATED
		var tempIconOffset = iconOffset.Clone();
		iconOffset.X = tempIconOffset.Y;
		iconOffset.Y = -tempIconOffset.X;
	}
	var scaledSpriteSize = new Size(
		sprite_get_width(_item.icon) * iconScale,
		sprite_get_height(_item.icon) * iconScale
	);
	if (_item.is_rotated)
	{
		// SWAP SPRITE SIZE IF ITEM IS ROTATED
		var tempSpriteSize = scaledSpriteSize.Clone();
		scaledSpriteSize.w = tempSpriteSize.h;
		scaledSpriteSize.h = tempSpriteSize.w;
	}
	var leftCornerPos = new Vector2(
		_position.X - (_size.w * 0.5),
		_position.Y - (_size.h * 0.5)
	);
	
	// DRAW WEAPONS WITH MAGAZINE IF RELOADED
	if (_item.category == "Weapon" && _item.type != "Melee")
	{
		if (_item.metadata.chamber_type == "Magazine")
		{
			_imageIndex = is_undefined(_item.metadata.magazine);
		}
	}
	
	draw_sprite_ext(
		_item.icon, _imageIndex,
		_position.X + iconOffset.X,
		_position.Y + iconOffset.Y,
		iconScale, iconScale, iconRotation, c_white, _imageAlpha
	);
	
	if (_item.is_known)
	{
		var backgroundPadding = 2;
		var backgroundHeight = 16
		var backgroundAlpha = 0.2;
	
		var drawFlagCount = array_length(_drawFlags);
		for (var i = 0; i < drawFlagCount; i++)
		{
			var drawFlag = _drawFlags[@ i];
			switch (drawFlag)
			{
				// PASS BACKGROUND FLAGS BEFORE TEXTS
				case DRAW_ITEM_FLAGS.NameBg:
				{
					draw_sprite_ext(
						sprGUIBg, 0/*gridSpriteIndex*/,
						leftCornerPos.X + backgroundPadding,
						leftCornerPos.Y + backgroundPadding,
						_size.w - (backgroundPadding * 2),
						backgroundHeight,
						0, c_white, backgroundAlpha
					);
				} break;
				case DRAW_ITEM_FLAGS.Name:
				{
					DrawItemAltText(_item.name, leftCornerPos.X + 5, leftCornerPos.Y + 3);
				} break;
				case DRAW_ITEM_FLAGS.NameShort:
				{
					DrawItemAltText(_item.short_name, leftCornerPos.X + 5, leftCornerPos.Y + 3);
				} break;
				case DRAW_ITEM_FLAGS.AltTextBg:
				{
					draw_sprite_ext(
						sprGUIBg, 0/*gridSpriteIndex*/,
						leftCornerPos.X + backgroundPadding,
						leftCornerPos.Y + _size.h - backgroundPadding - backgroundHeight,
						_size.w - (backgroundPadding * 2),
						backgroundHeight,
						0, c_white, backgroundAlpha
					);
				} break;
				case DRAW_ITEM_FLAGS.AltText:
				{
					var altText = GetItemAltText(_item);
					if (!is_undefined(altText))
					{
						DrawItemAltText(altText, leftCornerPos.X + 5, leftCornerPos.Y + _size.h - 18);
					}
				} break;
				case DRAW_ITEM_FLAGS.Compatible:
				{
				
				} break;
			}
		}
	}
}