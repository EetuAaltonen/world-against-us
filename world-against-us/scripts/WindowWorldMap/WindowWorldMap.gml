function WindowWorldMap(_elementId, _relativePosition, _size, _backgroundColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
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
			0, c_dkgray, 1
		);
		
		var staticMapData = global.MapDataHandlerRef.static_map_data;
		var mapDataEntryCount = staticMapData.GetEntryCount();
		for (var i = 0; i < mapDataEntryCount; i++)
		{
			var mapDataEntry = staticMapData.GetEntryByIndex(i);
			if (!is_undefined(mapDataEntry))
			{
				var positionOnGUI = new Vector2(
					calculatedPosition.X + ((mapDataEntry.position.X * mapScale) * mapZoom),
					calculatedPosition.Y + ((mapDataEntry.position.Y * mapScale) * mapZoom)
				);
				var iconScale = mapScale * mapZoom;
				var iconSize = new Size(mapDataEntry.size.w * iconScale, mapDataEntry.size.h * iconScale);
				draw_sprite_ext(
					sprGUIBg, 0,
					positionOnGUI.X,
					positionOnGUI.Y,
					iconSize.w, iconSize.h,
					0, mapDataEntry.icon_style.rgb_color,
					mapDataEntry.icon_alpha
				);
			}
		}
	}
}