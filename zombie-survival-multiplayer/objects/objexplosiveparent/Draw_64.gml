if (condition < maxCondition)
{
	var guiPos = PositionToGUI(new Vector2(x, y));
	draw_text(guiPos.X, guiPos.Y + 20, string(condition) + " / " + string(maxCondition));
}
