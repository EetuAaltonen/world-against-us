function WindowWorldMap(_elementId, _relativePosition, _size, _backgroundColor, _mapEntryRegistry) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	mapEntryRegistry = _mapEntryRegistry;
	mapZoomBase = 1;
	mapZoomStep = 0.25;
	mapZoom = mapZoomBase;
	mapMaxZoom = 3;
	mapScale = 1;
	positionOffset = new Vector2(0, 0);
	prevMousePos = undefined;
	sizeZoomed = size.Clone;
	calculatedPosition = position.Clone();

	
	static OnUpdate = function()
	{
		if (mouse_check_button_pressed(mb_left))
		{
			var mouseGUIPosition = MouseGUIPosition();
			prevMousePos = mouseGUIPosition;
		} else if (mouse_check_button(mb_left))
		{
			var mouseGUIPosition = MouseGUIPosition();
			positionOffset.X += (mouseGUIPosition.X - prevMousePos.X) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			positionOffset.Y += (mouseGUIPosition.Y - prevMousePos.Y) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			
			prevMousePos = mouseGUIPosition;
		} else if (mouse_check_button_released(mb_right))
		{
			positionOffset = new Vector2(0, 0);
		} else {
			if (mouse_wheel_up())
			{
				mapZoom += mapZoomStep;
			} else if (mouse_wheel_down())
			{
				mapZoom -= mapZoomStep;
			}
			
			mapZoom = min(mapMaxZoom, max(mapZoomStep, mapZoom));
		}
		
		mapScale = floor(((size.w * mapZoom) / room_width) * 1000) / 1000;
		sizeZoomed.w = (room_width * mapScale) * mapZoom;
		sizeZoomed.h = (room_height * mapScale) * mapZoom;
		calculatedPosition.X = position.X + positionOffset.X + ((size.w - sizeZoomed.w) * 0.5);
		calculatedPosition.Y = position.Y + positionOffset.Y + ((size.h - sizeZoomed.h) * 0.5);
	}
	
	static DrawContent = function()
	{
		// TODO: Fix world map background
		/*var backgroundSprite = sprMapPrologueBg;*/
		
		var backgroundScale = new Vector2(
			sizeZoomed.w,
			sizeZoomed.h
		);
		draw_sprite_ext(
			sprGUIBg, 0,
			calculatedPosition.X, calculatedPosition.Y,
			backgroundScale.X, backgroundScale.Y,
			0, c_white, 1
		);
		
		var entryCount = ds_list_size(mapEntryRegistry);
		for (var i = 0; i < entryCount; i++)
		{
			var mapEntry = mapEntryRegistry[| i];
			if (!is_undefined(mapEntry))
			{
				if (instance_exists(mapEntry.instance))
				{
					var positionOnGUI = new Vector2(
						calculatedPosition.X + ((mapEntry.instance.x * mapScale) * mapZoom),
						calculatedPosition.Y + ((mapEntry.instance.y * mapScale) * mapZoom)
					);
				
					var iconScale = mapScale * mapZoom;
					var iconSize = new Size(mapEntry.icon_size.w * iconScale, mapEntry.icon_size.h * iconScale);
					var iconAlpha = (!mapEntry.icon_style.constant_alpha && mapEntry.instance.mask_index == SPRITE_NO_MASK) ? 0.3 : 1;
					draw_sprite_ext(
						sprGUIBg, 0,
						positionOnGUI.X - (mapEntry.icon_offset.X * iconScale),
						positionOnGUI.Y - (mapEntry.icon_offset.Y * iconScale),
						iconSize.w, iconSize.h,
						0, mapEntry.icon_style.rgb_color, iconAlpha
					);
				}
			}
		}
	}
}