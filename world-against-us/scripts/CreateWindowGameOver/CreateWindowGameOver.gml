function CreateWindowGameOver(_gameWindowId, _zIndex)
{
	var windowSize = new Size(global.GUIW, global.GUIH);
	var windowStyle = new GameWindowStyle(c_black, 1);
	var gameOverWindow = new GameWindow(
		_gameWindowId,
		new Vector2(0, 0),
		windowSize, windowStyle, _zIndex
	);	
	
	var gameOverElements = ds_list_create();
	
	var gameOverTitle = new WindowText(
		"GameOverTitle",
		new Vector2(windowSize.w * 0.5, 500),
		undefined, undefined,
		"You have been robbed...",
		font_huge, fa_center, fa_middle, c_white, 1
	);
	
	var gameOverCallbackFunction = function()
	{
		// FAST TRAVEL BACK TO CAMP
		var fastTravelInfo = new WorldMapFastTravelInfo(undefined, undefined, ROOM_INDEX_CAMP);
		if (global.MultiplayerMode)
		{
			fastTravelInfo.source_region_id = global.NetworkRegionHandlerRef.region_id;
			fastTravelInfo.destination_region_id = global.NetworkRegionHandlerRef.region_id;
		}
		global.RoomChangeHandlerRef.RequestFastTravel(fastTravelInfo);
	}
	var gameOverTimer = new WindowTimerCallback(
		"GameOverTimer",
		new Vector2(0, 0),
		new Size(0, 0),
		undefined,
		5000, gameOverCallbackFunction 
	);
	
	ds_list_add(gameOverElements,
		gameOverTitle,
		gameOverTimer
	);
	
	// OVERRIDE WINDOW ONOPEN FUNCTION
	var overrideOnOpen = function()
	{
		// START GAME OVER TIMER
		var gameOverWindow = global.GameWindowHandlerRef.GetWindowById(GAME_WINDOW.GameOver);
		if (!is_undefined(gameOverWindow))
		{
			var gameOverTimerElement = gameOverWindow.GetChildElementById("GameOverTimer");
			if (!is_undefined(gameOverTimerElement))
			{
				gameOverTimerElement.timer.StartTimer();
			}
		}
	}
	gameOverWindow.OnOpen = overrideOnOpen;
	
	gameOverWindow.AddChildElements(gameOverElements);
	return gameOverWindow;
}