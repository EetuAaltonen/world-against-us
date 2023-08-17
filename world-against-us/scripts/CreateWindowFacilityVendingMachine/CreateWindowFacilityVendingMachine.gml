function CreateWindowFacilityVendingMachine(_zIndex, _facility)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var facilityWindow = new GameWindow(
		GAME_WINDOW.FacilityVendingMachine,
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var facilityElements = ds_list_create();
	// FACILITY TITLE
	var facilityTitle = new WindowText(
		"FacilityTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Vending Machine", font_large, fa_center, fa_middle, c_white, 1
		
	);
	
	// ITEM INVENTORY
	var facilityInventoryGrid = new WindowInventoryGrid(
		"FacilityInventoryGrid",
		new Vector2(10, 70),
		new Size(windowSize.w - 20, 0),
		undefined, _facility.inventory
	);
	
	ds_list_add(facilityElements,
		facilityTitle,
		facilityInventoryGrid
	);
	
	facilityWindow.AddChildElements(facilityElements);
	return facilityWindow;
}