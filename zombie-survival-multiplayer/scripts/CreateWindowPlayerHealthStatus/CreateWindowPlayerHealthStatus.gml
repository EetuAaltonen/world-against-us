function CreateWindowPlayerHealthStatus(_zIndex)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	var healthStatusWindow = new GameWindow(
		GAME_WINDOW.PlayerHealthStatus,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var healthStatusElements = ds_list_create();
	// HEALTH STATUS
	var healthStatusTitle = new WindowText(
		"HealthStatusTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Health Status", font_large, fa_center, fa_middle, c_white, 1
		
	);
	// HEALTH STATUS PANEL
	var healthStatusPanelSize = new Size(windowSize.w - 20, 700);
	var healthStatusPanel = new WindowPanel(
		"HealthStatusPanel",
		new Vector2(10, 60),
		healthStatusPanelSize,
		c_dkgray
	);
	
	// MEDICINE POCKETS
	var medicinePocketTitle = new WindowText(
		"MedicinePocketTitle",
		new Vector2(10, 780),
		undefined, undefined,
		"Medicine Pockets", font_default, fa_left, fa_middle, c_white, 1
		
	);
	var medicinePocketGridSize = new Size(windowSize.w * 0.33, 0);
	var medicinePocketGrid = new WindowInventoryGrid(
		"MedicinePocketGrid",
		new Vector2(10, 800),
		medicinePocketGridSize,
		undefined,
		global.PlayerMedicinePockets
	);
	ds_list_add(
		healthStatusElements,
		healthStatusPanel,
		healthStatusTitle,
		medicinePocketTitle,
		medicinePocketGrid
	);
	
	var healthStatusPanelElements = ds_list_create();
	// HEALTH HUMAN BODY
	var playerHealthImage = new WindowImage(
		"PlayerHealthImage",
		new Vector2(0, 0),
		new Size(healthStatusPanelSize.w, healthStatusPanelSize.h),
		undefined,
		sprHumanBody, 0, 1, 0
	);
	// HEALTH BARS
	var healthBarSize = new Size(140, 15);
	var healthBarBgColor = c_black;
	var healthBarColor = #fc2c03;
	var healthBarTitleColor = c_black;
	var healthBarTextColor = c_orange;
	// HEAD
	var playerHeadHealthBar = new WindowHealthBar(
		"PlayerHeadHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.67 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.05),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.Head,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// CHEST
	var playerChestHealthBar = new WindowHealthBar(
		"PlayerChestHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.5 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.22),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.Chest,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// RIGHT ARM
	var playerRightArmHealthBar = new WindowHealthBar(
		"PlayerRightArmHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.23 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.4),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.RightArm,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// LEFT ARM
	var playerLeftArmHealthBar = new WindowHealthBar(
		"PlayerLeftArmHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.77 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.4),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.LeftArm,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// STOMACH
	var playerStomachHealthBar = new WindowHealthBar(
		"PlayerStomachHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.5 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.4),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.Stomach,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// RIGHT LEG
	var playerRightLegHealthBar = new WindowHealthBar(
		"PlayerRightLegHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.28 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.75),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.RightLeg,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	// LEFT LEG
	var playerLeftLegHealthBar = new WindowHealthBar(
		"PlayerLeftLegHealthBar",
		new Vector2(healthStatusPanelSize.w * 0.72 - (healthBarSize.w * 0.5), healthStatusPanelSize.h * 0.75),
		healthBarSize,
		global.InstancePlayer.character, CHARACTER_BODY_PARTS.LeftLeg,
		healthBarBgColor, healthBarColor, healthBarTitleColor, healthBarTextColor
	);
	
	ds_list_add(healthStatusPanelElements,
		playerHealthImage,
		playerHeadHealthBar,
		playerChestHealthBar,
		playerStomachHealthBar,
		playerRightArmHealthBar,
		playerLeftArmHealthBar,
		playerRightLegHealthBar,
		playerLeftLegHealthBar
	);
	healthStatusWindow.AddChildElements(healthStatusElements);
	healthStatusPanel.AddChildElements(healthStatusPanelElements);
	
	return healthStatusWindow;
}