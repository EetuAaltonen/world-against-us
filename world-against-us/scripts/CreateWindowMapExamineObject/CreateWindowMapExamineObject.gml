function CreateWindowMapExamineObject(_zIndex, _examineObjectData)
{
	var mapWindowElement = parentWindow.GetChildElementById("MapElement");
	if (!is_undefined(mapWindowElement))
	{
		var windowSize = new Size(500, mapWindowElement.size.h);
		var windowStyle = new GameWindowStyle(c_black, 0.9);
		var examineObjectWindow = new GameWindow(
			GAME_WINDOW.MapExamineObject,
			new Vector2(0, mapWindowElement.position.Y),
			windowSize, windowStyle, _zIndex
		);
		var examineObjectElements = ds_list_create();
	
		var examineTitle = new WindowText(
			"ExamineTitle",
			new Vector2(30, 30),
			undefined, undefined,
			_examineObjectData.display_name,
			font_default, fa_left, fa_middle, c_white, 1
		);
		
		var iconSize = new Size(100, 100);
		var examineIcon = new WindowImage(
			"ExamineIcon",
			new Vector2((windowSize.w * 0.5) - (iconSize.w * 0.5), 80),
			iconSize, c_dkgray,
			_examineObjectData.icon, 0, 1, 0
		);
		
		var examineDescription = new WindowText(
			"ExamineDescription",
			new Vector2(30, 200),
			undefined, undefined,
			_examineObjectData.description,
			font_small, fa_left, fa_middle, c_white, 1
		);
	
		ds_list_add(examineObjectElements,
			examineTitle,
			examineIcon,
			examineDescription
		);
	
		examineObjectWindow.AddChildElements(examineObjectElements);
	}
	return examineObjectWindow;
}