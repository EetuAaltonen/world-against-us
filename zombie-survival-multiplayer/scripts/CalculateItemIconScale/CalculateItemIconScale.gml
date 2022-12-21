function CalculateItemIconScale(_item, _gridCellSize)
{
	// CALCULATE ICON SIZE
	var padding = 0.85;
	var iconScale = 1;
	if (_item.isRotated)
	{
		iconScale = ScaleSpriteToFitSize(
			_item.icon,
			new Size(
				(_gridCellSize.w * padding) * _item.size.h,
				(_gridCellSize.h * padding) * _item.size.w
			)
		);
	} else {
		iconScale = ScaleSpriteToFitSize(
			_item.icon,
			new Size(
				(_gridCellSize.w * padding) * _item.size.w,
				(_gridCellSize.h * padding) * _item.size.h
			)
		);
	}
	return iconScale;
}