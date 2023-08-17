function ListDrawJournalQuestStep(_position, _size, _questStepProgressData)
{
	var outlineWidth = 2;
	var outlineColor = _questStepProgressData.is_completed ? #21c208 : c_black;
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X, _position.Y,
		_size.w, _size.h,
		0, outlineColor, 1
	);
	
	draw_sprite_ext(
		sprGUIBg, 0,
		_position.X + outlineWidth, _position.Y + outlineWidth,
		_size.w - (outlineWidth * 2), _size.h - (outlineWidth * 2),
		0, c_ltgray, 1
	);
	
	var databaseQuestStep = _questStepProgressData.database_quest_step;
	var iconSize = new Size(90, _size.h - 20);
	var iconScale = ScaleSpriteToFitSize(databaseQuestStep.icon, iconSize);
	var iconCenter = CenterSpriteOffset(databaseQuestStep.icon, iconScale);
	var iconMargin = 5;
	draw_sprite_ext(
		databaseQuestStep.icon, 0,
		_position.X + outlineWidth + (iconSize.w * 0.5) + iconCenter.X + iconMargin,
		_position.Y + outlineWidth + (_size.h * 0.5) + iconCenter.Y,
		iconScale, iconScale,
		0, c_ltgray, 1
	);
	
	draw_set_valign(fa_middle);
	draw_text(_position.X + 100, _position.Y + (_size.h * 0.5), string("> {0}", databaseQuestStep.name));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}