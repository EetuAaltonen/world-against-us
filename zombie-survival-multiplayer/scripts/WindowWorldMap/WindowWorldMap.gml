function WindowWorldMap(_elementId, _relativePosition, _size, _backgroundColor, _mapEntryRegistry) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	mapEntryRegistry = _mapEntryRegistry;
	mapZoomBase = 1;
	mapZoomStep = 0.25;
	mapZoom = mapZoomBase;
	mapMaxZoom = 3;
	mapScale = 1;
	positionOffset = new Vector2(0, 0);
	prevMousePos = MouseWorldPosition();
	positionFinal = position.Clone();
	sizeZoomed = size.Clone;

	
	static OnUpdate = function()
	{
		if (mouse_check_button(mb_left))
		{
			var mouseWorldPosition = MouseWorldPosition();
			positionOffset.X += (mouseWorldPosition.X - prevMousePos.X) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			positionOffset.Y += (mouseWorldPosition.Y - prevMousePos.Y) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			
			prevMousePos = mouseWorldPosition;
		} else if (mouse_check_button_released(mb_right))
		{
			positionOffset = new Vector2(0, 0);
			mapZoom = mapZoomBase;
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
		sizeZoomed.w = size.w * mapZoom;
		sizeZoomed.h = size.h * mapZoom;
		positionFinal.X = position.X + positionOffset.X + ((size.w - sizeZoomed.w) * 0.5);
		positionFinal.Y = position.Y + positionOffset.Y + ((size.h - sizeZoomed.h) * 0.5);
	}
	
	static DrawContent = function()
	{
		var backgroundSprite = sprMapPrologueBg;
		var backgroundScale = new Vector2(
			sizeZoomed.w / sprite_get_width(backgroundSprite),
			sizeZoomed.h / sprite_get_height(backgroundSprite) 
		);

		draw_sprite_ext(
			backgroundSprite, 0,
			positionFinal.X, positionFinal.Y,
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
					var var positionOnGUI = new Vector2(
						positionFinal.X + (mapEntry.instance.x * mapScale),
						positionFinal.Y + (mapEntry.instance.y * mapScale)
					);
				
					var iconScale = mapScale;
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