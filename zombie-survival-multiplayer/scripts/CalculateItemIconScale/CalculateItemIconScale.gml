function CalculateItemIconScale(_item, _gridCellSize)
{
	var iconScale = 1;
	if (_item.is_rotated)
	{
		iconScale = ScaleSpriteToFitSize(
			_item.icon,
			new Size(
				_gridCellSize.w * _item.size.h,
				_gridCellSize.h * _item.size.w
			)
		);
	} else {
		iconScale = ScaleSpriteToFitSize(
			_item.icon,
			new Size(
				_gridCellSize.w * _item.size.w,
				_gridCellSize.h * _item.size.h
			)
		);
	}
	return iconScale;
}