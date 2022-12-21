function CreateWindowPlayerSkills(_zIndex)
{
	var windowSize = new Size(global.GUIW * 0.4, global.GUIH - global.ObjHud.hudHeight);
	var windowStyle = new GameWindowStyle(c_black, 0.9);
	
	var skillsWindow = new GameWindow(
		GAME_WINDOW.PlayerSkills,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);
	
	var skillsElements = ds_list_create();
	// SKILLS TITLE
	var skillsTitle = new WindowText(
		"SkillsTitle",
		new Vector2(windowSize.w * 0.5, 30),
		undefined, undefined,
		"Skills", font_large, fa_center, fa_middle, c_white, 1
		
	);
	
	// SKILLS PANEL
	var skillsPanelSize = new Size(windowSize.w - 20, windowSize.h - 100);
	var skillsPanel = new WindowPanel(
		"SkillsPanel",
		new Vector2(10, 60),
		skillsPanelSize,
		c_dkgray
	);
	
	ds_list_add(
		skillsElements,
		skillsPanel,
		skillsTitle
	);
	
	var skillsPanelElements = ds_list_create();
	// SKILLS BARS
	var skillBarSize = new Size(skillsPanelSize.w * 0.6, 30);
	var skillBarBgColor = c_black;
	var skillBarColor = #0d541a;
	var skillBarTitleColor = c_white;
	var skillBarTextColor = #808080;
	// ENDURANCE
	var playerSkillBarEndurance = new WindowProgressBar(
		"playerSkillBarEndurance",
		new Vector2(20, 40),
		skillBarSize, skillBarBgColor,
		10, 100, "Endurance",
		skillBarColor, skillBarTitleColor, skillBarTextColor, true
	);
	
	ds_list_add(skillsPanelElements,
		playerSkillBarEndurance
	);
	skillsWindow.AddChildElements(skillsElements);
	skillsPanel.AddChildElements(skillsPanelElements);
	
	return skillsWindow;
}