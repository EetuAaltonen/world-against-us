function ListDrawJournalQuest(_position, _size, _questProgressData)
{
	var outlineWidth = 2;
	var outlineColor = _questProgressData.is_completed ? #21c208 : c_black;
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
	
	var quest = global.QuestData[? _questProgressData.quest_id];
	var iconSize = new Size(80, _size.h - 20);
	var iconScale = ScaleSpriteToFitSize(quest.icon, iconSize);
	var iconCenter = CenterSpriteOffset(quest.icon, iconScale);
	draw_sprite_ext(
		quest.icon, 0,
		_position.X + outlineWidth + (iconSize.w * 0.5) + iconCenter.X,
		_position.Y + outlineWidth + (_size.h * 0.5) + iconCenter.Y,
		iconScale, iconScale,
		0, c_ltgray, 1
	);
	
	draw_set_valign(fa_middle);
	draw_text(_position.X + 100, _position.Y + (_size.h * 0.5), string("> {0}", quest.name));
	
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}