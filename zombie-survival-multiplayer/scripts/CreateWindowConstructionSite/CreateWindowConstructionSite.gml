function CreateWindowConstructionSite(_zIndex, _materialSlotInventories, _constructionSiteInstance)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var constrWindow = new GameWindow(
		GAME_WINDOW.ConstructionSite,
		new Vector2(global.GUIW - windowSize.w, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var constrElements = ds_list_create();
	// CONSTR TITLE
	var constrTitle = new WindowText(
		"ConstrTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Construction Site", font_large, fa_center, fa_middle, c_white, 1
	);
	
	// ITEM HOLDERS
	var materialItemHolderSize = new Size(150, 150);
	var materialItemHolderPadding = 20;
	var materialSlotCount = array_length(_materialSlotInventories);
	for (var i = 0; i < materialSlotCount; i++)
	{
		var materialSlotInventory = _materialSlotInventories[@ i];
		var materialItemHolderPos = new Vector2(
			materialItemHolderPadding + ((materialItemHolderSize.w + materialItemHolderPadding) * i),
			100
		);
		var materialItemHolder = new WindowItemSlot(
			string("MaterialItemHolder{0}", i),
			materialItemHolderPos,
			materialItemHolderSize,
			c_gray, materialSlotInventory
		);
		
		ds_list_add(constrElements,
			materialItemHolder
		);
	}
	
	var buttonSize = new Size(150, 100);
	var buttonStyle = new ButtonStyle(
		buttonSize, 0,
		#48a630, #2c8017,
		fa_left, fa_top,
		c_black, c_black,
		font_large,
		fa_center, fa_middle
	);
	var buildButton = new WindowButtonCondition(
		"BuildButton",
		new Vector2((windowSize.w * 0.5) - (buttonSize.w * 0.5) , 500),
		buttonSize,
		buttonStyle.button_background_color, "Build", buttonStyle, OnClickConstructionWindowBuild,
		{ blueprint_tag: "construction_site", material_slots: _materialSlotInventories, construction_site: _constructionSiteInstance }
	);
	
	ds_list_add(constrElements,
		constrTitle,
		buildButton
	);
	
	constrWindow.AddChildElements(constrElements);
	return constrWindow;
}