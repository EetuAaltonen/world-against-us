function CompareMapIcons(sourceMapIcon, compareMapIcon)
{
	var isRenderedFirst = false;
	
	if (sourceMapIcon.position.Y < compareMapIcon.position.Y)
	{
		isRenderedFirst = true;
	} else if (sourceMapIcon.position.Y == compareMapIcon.position.Y)
	{
		if (sourceMapIcon.position.X <= compareMapIcon.position.X)
		{
			isRenderedFirst = true;
		}
	}
	
	return isRenderedFirst;
}