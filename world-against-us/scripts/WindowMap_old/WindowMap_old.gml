function WindowMap_old(_elementId, _relativePosition, _size, _backgroundColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
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
	
	highlighted_icon = undefined;
	highlighted_position = undefined;
	highlighted_size = undefined;
	highlighted_examine_data = undefined;
	
	UpdateFollowTarget();
	
	static OnUpdate = function()
	{
		if (parentWindow.isFocused)
		{
			if (keyboard_check(vk_alt))
			{
				if (mouse_check_button_pressed(mb_left))
				{
					if (!is_undefined(highlighted_icon))
					{
						if (!is_undefined(highlighted_examine_data))
						{
							var currentGUIState = global.GUIStateHandlerRef.GetGUIState();
							
							if (currentGUIState.action == GUI_ACTION.ExamineObject)
							{
								global.GUIStateHandlerRef.CloseCurrentGUIState();
							}
							
							if (global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.ExamineObject, [GAME_WINDOW.MapExamineObject]))
							{
								global.GameWindowHandlerRef.OpenWindowGroup([
									CreateWindowMapExamineObject(GAME_WINDOW.MapExamineObject, parentWindow.zIndex - 1, highlighted_examine_data)
								]);
							}
						}
					}
				}
			} else if (mouse_check_button_pressed(mb_left))
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
				if (!is_undefined(prevMousePos))
				{
					var mouseGUIPosition = MouseGUIPosition();
					positionOffset.X += (mouseGUIPosition.X - prevMousePos.X) * min(3, max(1.5, (mapZoomBase / mapZoom)));
					positionOffset.Y += (mouseGUIPosition.Y - prevMousePos.Y) * min(3, max(1.5, (mapZoomBase / mapZoom)));
			
					prevMousePos = mouseGUIPosition;
				}
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
		
		var mousePosition = MouseGUIPosition();
		highlighted_icon = undefined;
		highlighted_position = undefined;
		highlighted_size = undefined;
		highlighted_examine_data = undefined;
		
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
						
						// CHECK HIGHLIGHTED
						if (point_in_rectangle(mousePosition.X, mousePosition.Y, positionOnGUI.X, positionOnGUI.Y, positionOnGUI.X + iconSize.w, positionOnGUI.Y + iconSize.h))
						{
							if (is_undefined(highlighted_icon))
							{
								highlighted_icon = mapIconToDraw;
								highlighted_position = positionOnGUI;
								highlighted_size = iconSize;
							} else {
								if (mapIconToDraw.origin.Y <= highlighted_icon.origin.Y)
								{
									highlighted_icon = mapIconToDraw;
									highlighted_position = positionOnGUI;
									highlighted_size = iconSize;
								}
							}
						}
						
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
			
			if (!is_undefined(highlighted_icon))
			{
				var objectExamineData = GetDataByObjectNameOrRelationFromMap(highlighted_icon.object_name, global.ObjectExamineData);
				if (!is_undefined(objectExamineData))
				{
					highlighted_examine_data = objectExamineData;
					
					draw_set_font(font_small);
					draw_set_color(c_black);
					draw_set_valign(fa_middle);
					draw_set_halign(fa_center);
					
					draw_text(
						highlighted_position.X + (highlighted_size.w * 0.5),
						highlighted_position.Y + highlighted_size.h + 10,
						objectExamineData.display_name
					);
					
					// RESET DRAW PROPERTIES
					ResetDrawProperties();
				}
			}
			
			if (follow_target != noone)
			{
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
}