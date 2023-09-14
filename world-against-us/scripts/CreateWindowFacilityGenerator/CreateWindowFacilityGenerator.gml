function CreateWindowFacilityGenerator(_gameWindowId, _zIndex, _facility)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var facilityWindow = new GameWindow(
		_gameWindowId,
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var facilityElements = ds_list_create();
	// FACILITY TITLE
	var facilityTitle = new WindowText(
		"FacilityTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Generator", font_large, fa_center, fa_middle, c_white, 1
	);
	
	// FUEL CAN HOLDER
	var facilityItemHolderSize = new Size(200, 200)
	var facilityItemHolder = new WindowItemSlot(
		"FacilityItemHolder",
		new Vector2((windowSize.w * 0.5) - (facilityItemHolderSize.w * 0.5), 100),
		facilityItemHolderSize,
		c_gray, _facility.inventory
	);
	
	ds_list_add(facilityElements,
		facilityTitle,
		facilityItemHolder
	);
	
	facilityWindow.AddChildElements(facilityElements);
	return facilityWindow;
}