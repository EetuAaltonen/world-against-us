function WindowMap(_elementId, _relativePosition, _size, _backgroundColor) : WindowElement(_elementId, _relativePosition, _size, _backgroundColor) constructor
{
	target_map_location = undefined;
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
	
	is_following_target = true;
	vision_radius = 1000;
	
	scouting_drone_movement_input = new DeviceInputMovement(0, 0, 0, 0);
	
	highlighted_icon = undefined;
	highlighted_position = undefined;
	highlighted_size = undefined;
	highlighted_examine_data = undefined;
	
	static OnUpdate = function()
	{
		if (!is_undefined(target_map_location))
		{
			var scoutingDrone = global.MapDataHandlerRef.scouting_drone;
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
							
								global.GUIStateHandlerRef.RequestGUIAction(GUI_ACTION.ExamineObject, [
									CreateWindowMapExamineObject(GAME_WINDOW.MapExamineObject, parentWindow.zIndex - 1, highlighted_examine_data)
								], GUI_CHAIN_RULE.Append);
							}
						}
					}
				} else if (mouse_check_button_pressed(mb_left))
				{
					var mouseGUIPosition = MouseGUIPosition();
					prevMousePos = mouseGUIPosition;
					if (is_following_target)
					{
						// RECENTER MAP
						ResetPositionOffset();
					}
					is_following_target = false;
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
				
				if (!is_undefined(scoutingDrone))
				{
					GetLocalPlayerMovementInput(scouting_drone_movement_input);
					var hInput = scouting_drone_movement_input.key_right - scouting_drone_movement_input.key_left;
					var vInput = scouting_drone_movement_input.key_down - scouting_drone_movement_input.key_up;
					var flySpeed = 8;
					scoutingDrone.position.X += flySpeed * hInput;
					scoutingDrone.position.Y += flySpeed * vInput;
				}
			}

			var roomSize = target_map_location.size;
			mapScale = floor(((size.w * mapZoom) / roomSize.w) * 1000) / 1000;
			iconScale = mapScale * mapZoom;
			sizeZoomed.w = (roomSize.w * iconScale);
			sizeZoomed.h = (roomSize.h * iconScale);
			calculatedPosition.X = position.X + positionOffset.X;
			calculatedPosition.Y = position.Y + positionOffset.Y;
			
			if (is_following_target && !is_undefined(scoutingDrone))
			{
				var targetOffset = CalculateFollowTargetOffset(scoutingDrone.position);
				calculatedPosition.X -= targetOffset.X;
				calculatedPosition.Y -= targetOffset.Y;
			} else {
				calculatedPosition.X += ((size.w - sizeZoomed.w) * 0.5);
				calculatedPosition.Y += ((size.h - sizeZoomed.h) * 0.5);
			}
		}
	}
	
	static UpdateFollowTarget = function()
	{
		is_following_target = !is_undefined(global.MapDataHandlerRef.scouting_drone);
	}
	
	static ResetPositionOffset = function()
	{
		positionOffset.X = 0;
		positionOffset.Y = 0;
	}
	
	static CalculateFollowTargetOffset = function(_targetPosition)
	{
		var roomSize = target_map_location.size;
		var targetOffset = new Vector2(
			((_targetPosition.X / roomSize.w) * sizeZoomed.w) - (size.w * 0.5),
			((_targetPosition.Y / roomSize.h) * sizeZoomed.h) - (size.h * 0.5)
		);
		return targetOffset;
	}
	
	static DrawContent = function()
	{
		if (!is_undefined(target_map_location))
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
		
			// PATROL
			if (global.DEBUGMODE)
			{
				var patrolPath = target_map_location.patrol_path;
				if (!is_undefined(patrolPath))
				{
					var pathPointCount = path_get_number(patrolPath);
					var prevPathPoint = undefined;
					for (var i = 0; i < pathPointCount; i++)
					{
						var pathPoint = new Vector2(
							path_get_point_x(patrolPath, i),
							path_get_point_y(patrolPath, i)
						);
						var pathPointOnGUI = CalculateIconPosOnGUI(pathPoint);
						draw_circle_color(pathPointOnGUI.X, pathPointOnGUI.Y, 4, c_white, c_white, false);
		
						if (!is_undefined(prevPathPoint))
						{
							var prevPathPointOnGUI = CalculateIconPosOnGUI(prevPathPoint);
							draw_line_color(
								pathPointOnGUI.X, pathPointOnGUI.Y,
								prevPathPointOnGUI.X, prevPathPointOnGUI.Y,
								c_lime, c_lime
							);
						}
						prevPathPoint = pathPoint;
					}
				}
			}
		
			// STATIC AND DYNAMIC DATA
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
					//if (rectangle_in_circle(mapIconToDraw.position.X, mapIconToDraw.position.Y, mapIconToDraw.position.X + mapIconToDraw.size.w, mapIconToDraw.position.Y + mapIconToDraw.size.h, follow_target.x, follow_target.y, vision_radius))
					//{
						var positionOnGUI = CalculateIconPosOnGUI(mapIconToDraw.position);
						var iconSize = CalculateIconSizeOnGUI(mapIconToDraw.size);
						
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
					//}
				}
			}
		
			var scoutingDrone = global.MapDataHandlerRef.scouting_drone;
			if (!is_undefined(scoutingDrone))
			{
				var positionOnGUI = CalculateIconPosOnGUI(scoutingDrone.position);
				var droneScale = max(0.4, iconScale);
				draw_sprite_ext(
					scoutingDrone.spr_index, 0,
					positionOnGUI.X, positionOnGUI.Y,
					droneScale, droneScale, 0, c_white, 1
				);
			
				draw_circle_color(
					positionOnGUI.X,
					positionOnGUI.Y,
					vision_radius * iconScale,
					c_red, c_red, true
				);
			}
		
			/*if (instance_exists(follow_target))
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
				}
			}*/
		}
	}
	
	static CalculateIconPosOnGUI = function(_iconPosition)
	{
		return new Vector2(
			calculatedPosition.X + (_iconPosition.X * iconScale),
			calculatedPosition.Y + (_iconPosition.Y * iconScale)
		);
	}
	
	static CalculateIconSizeOnGUI = function(_iconSize)
	{
		return new Size(_iconSize.w * iconScale, _iconSize.h * iconScale);
	}
}