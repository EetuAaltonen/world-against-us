function WindowMap(_elementId, _relativePosition, _size, _backgroundColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	mapZoomBase = 1;
	mapZoomStep = 0.25;
	mapZoom = mapZoomBase;
	mapMaxZoom = 3;
	mapScale = 1;
	iconScale = 1;
	positionOffset = new Vector2(0, 0);
	prevMousePos = undefined;
	sizeZoomed = size.Clone();
	calculatedPosition = position.Clone();
	
	follow_target = noone;
	is_following = true;
	vision_radius = 0;
	
	UpdateFollowTarget();
	
	static OnUpdate = function()
	{
		if (mouse_check_button_pressed(mb_left))
		{
			var mouseGUIPosition = MouseGUIPosition();
			prevMousePos = mouseGUIPosition;
			if (is_following)
			{
				if (instance_exists(follow_target))
				{
					// RECENTER MAP
					ResetPositionOffset();
				}
			}
			is_following = false;
		} else if (mouse_check_button(mb_left))
		{
			var mouseGUIPosition = MouseGUIPosition();
			positionOffset.X += (mouseGUIPosition.X - prevMousePos.X) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			positionOffset.Y += (mouseGUIPosition.Y - prevMousePos.Y) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			
			prevMousePos = mouseGUIPosition;
		} else if (mouse_check_button_released(mb_right))
		{
			ResetPositionOffset();
			mapZoom = mapZoomBase;
			UpdateFollowTarget();
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
		iconScale = mapScale * mapZoom;
		sizeZoomed.w = (room_width * iconScale);
		sizeZoomed.h = (room_height * iconScale);
		calculatedPosition.X = position.X + positionOffset.X;
		calculatedPosition.Y = position.Y + positionOffset.Y;
		
		if (!instance_exists(follow_target))
		{
			if (follow_target != noone)
			{
				follow_target = noone;
				vision_radius = 0;
				is_following = false;
			}
		}
		
		if (is_following)
		{
			var targetOffset = CalculateFollowTargetOffset();
			calculatedPosition.X -= targetOffset.X;
			calculatedPosition.Y -= targetOffset.Y;
		} else {
			calculatedPosition.X += ((size.w - sizeZoomed.w) * 0.5);
			calculatedPosition.Y += ((size.h - sizeZoomed.h) * 0.5);
		}
	}
	
	static UpdateFollowTarget = function()
	{
		if (instance_exists(global.InstanceDrone))
		{
			follow_target = global.InstanceDrone;
			vision_radius = follow_target.visionRadius;
			is_following = true;
		} else if (instance_exists(global.InstancePlayer))
		{
			follow_target = global.InstancePlayer;
			vision_radius = follow_target.character.vision_radius;
			is_following = true;
		}
	}
	
	static ResetPositionOffset = function()
	{
		positionOffset.X = 0;
		positionOffset.Y = 0;
	}
	
	static CalculateFollowTargetOffset = function()
	{
		var targetOffset = new Vector2(
			((follow_target.x / room_width) * sizeZoomed.w) - (size.w * 0.5),
			((follow_target.y / room_height) * sizeZoomed.h) - (size.h * 0.5)
		);
		return targetOffset;
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
		
		if (instance_exists(follow_target))
		{
			var staticMapData = global.MapDataHandlerRef.static_map_data;
			var dynamicMapData = global.MapDataHandlerRef.dynamic_map_data;
			var mapIconCount = staticMapData.GetMapIconCount() + dynamicMapData.GetMapIconCount();
			for (var i = 0, j = 0; (i + j) < mapIconCount;)
			{
				var staticMapIcon = staticMapData.GetMapIconByIndex(i);
				var dynamicMapIcon = dynamicMapData.GetMapIconByIndex(j);
			
				var mapIconToDraw = undefined;
				if (is_undefined(staticMapIcon))
				{
					mapIconToDraw = dynamicMapIcon;
					j++;
				} else if (is_undefined(dynamicMapIcon))
				{
					mapIconToDraw = staticMapIcon;
					i++;	
				} else {
					if (staticMapIcon.position.Y == dynamicMapIcon.position.Y)
					{
						if (staticMapIcon.position.X <= dynamicMapIcon.position.X)
						{
							mapIconToDraw = staticMapIcon;
							i++;
						} else {
							mapIconToDraw = dynamicMapIcon;
							j++;
						}
					} else if (staticMapIcon.position.Y < dynamicMapIcon.position.Y)
					{
						mapIconToDraw = staticMapIcon;
						i++;
					} else {
						mapIconToDraw = dynamicMapIcon;
						j++;
					}
				}
			
				if (!is_undefined(mapIconToDraw))
				{
					if (rectangle_in_circle(mapIconToDraw.position.X, mapIconToDraw.position.Y, mapIconToDraw.position.X + mapIconToDraw.size.w, mapIconToDraw.position.Y + mapIconToDraw.size.h, follow_target.x, follow_target.y, vision_radius))
					{
						var positionOnGUI = new Vector2(
							calculatedPosition.X + (mapIconToDraw.position.X * iconScale),
							calculatedPosition.Y + (mapIconToDraw.position.Y * iconScale)
						);
						var iconSize = new Size(mapIconToDraw.size.w * iconScale, mapIconToDraw.size.h * iconScale);
						draw_sprite_ext(
							sprGUIBg, 0,
							positionOnGUI.X,
							positionOnGUI.Y,
							iconSize.w, iconSize.h,
							0, mapIconToDraw.icon_style.rgb_color,
							mapIconToDraw.icon_alpha
						);
						
						if (global.DEBUGMODE)
						{
							var originOnGUI = new Vector2(
								calculatedPosition.X + ((mapIconToDraw.origin.X * mapScale) * mapZoom),
								calculatedPosition.Y + ((mapIconToDraw.origin.Y * mapScale) * mapZoom)
							);
							draw_circle_color(
								originOnGUI.X,
								originOnGUI.Y,
								2, c_red, c_red,
								false
							);
					
							draw_set_font(font_small);
							draw_text_color(
								positionOnGUI.X,
								positionOnGUI.Y,
								string(i),
								c_red, c_red, c_red, c_red,
								1
							);
							// RESET DRAW PROPERTIES
							ResetDrawProperties();
						}
					}
				}
			}
			
			var positionOnGUI = new Vector2(
				calculatedPosition.X + (follow_target.x * iconScale),
				calculatedPosition.Y + (follow_target.y * iconScale)
			);
		
			draw_sprite_ext(
				follow_target.sprite_index, 0,
				positionOnGUI.X,
				positionOnGUI.Y,
				iconScale, iconScale, 1, c_white, 1
			);
		
			draw_circle_color(
				positionOnGUI.X,
				positionOnGUI.Y,
				vision_radius * iconScale,
				c_red, c_red, true
			);
		}
	}
}