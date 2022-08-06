if (initPulseLine)
{
	initPulseLine = false;
	
	ds_list_add(pulseLinePoints,
		new Vector2(120, global.GUIH - 50),
		new Vector2(70, global.GUIH - 50),
		new Vector2(60, global.GUIH - 30),
		new Vector2(50, global.GUIH - 60),
		new Vector2(40, global.GUIH - 40),
		new Vector2(10, global.GUIH - 40)
	);
}
