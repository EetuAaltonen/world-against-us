function CreateWindowFacilityAmmunitionSortingMachine(_gameWindowId, _zIndex, _facility)
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
		"Ammunition Sorting Machine", font_large, fa_center, fa_middle, c_white, 1
		
	);
	
	// ITEM INVENTORY
	var facilityInventoryGrid = new WindowInventoryGrid(
		"FacilityInventoryGrid",
		new Vector2(10, 70),
		new Size(windowSize.w - 20, 0),
		undefined, _facility.inventory
	);
	
	var buttonSize = new Size(200, 60);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#174180, #172580,
		fa_left, fa_top,
		c_black, c_black,
		font_default,
		fa_center, fa_middle
	);
	var facilityMagazineFillButton = new WindowButton(
		"MagazineFillButton",
		new Vector2(100, 500),
		buttonSize, buttonStyle.button_background_color, "Fill Magazines", buttonStyle, OnClickAmmunitionSortButton
	);
	
	ds_list_add(facilityElements,
		facilityTitle,
		facilityInventoryGrid,
		facilityMagazineFillButton
	);
	
	facilityWindow.AddChildElements(facilityElements);
	return facilityWindow;
}