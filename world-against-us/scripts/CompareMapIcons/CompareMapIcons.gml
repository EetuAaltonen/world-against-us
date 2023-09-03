function CompareMapIcons(sourceMapIcon, compareMapIcon)
{
	var isRenderedFirst = false;
	
	if (sourceMapIcon.origin.Y < compareMapIcon.origin.Y)
	{
		isRenderedFirst = true;
	} else if (sourceMapIcon.origin.Y == compareMapIcon.origin.Y)
	{
		if (sourceMapIcon.origin.X <= compareMapIcon.origin.X)
		{
			isRenderedFirst = true;
		}
	}
	
	return isRenderedFirst;
}