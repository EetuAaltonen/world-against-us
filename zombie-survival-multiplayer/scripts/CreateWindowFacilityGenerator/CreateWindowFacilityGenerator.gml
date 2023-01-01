function CreateWindowFacilityGenerator(_zIndex, _facility)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var facilityWindow = new GameWindow(
		GAME_WINDOW.Facility,
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
	var facillityItemHolderSize = new Size(200, 200)
	var facillityItemHolder = new WindowItemHolder(
		"FacillityItemHolder",
		new Vector2((windowSize.w * 0.5) - (facillityItemHolderSize.w * 0.5), 100),
		facillityItemHolderSize,
		c_blue, _facility.inventory
	);
	
	ds_list_add(facilityElements,
		facilityTitle,
		facillityItemHolder
	);
	
	facilityWindow.AddChildElements(facilityElements);
	return facilityWindow;
}