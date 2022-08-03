if (global.ShowHUD)
{
	var xPos = 150;
	var yPos = global.ViewH - 200;
	draw_sprite_ext(
		sprHeart, 0,
		xPos, yPos,
		heartScale, heartScale,
		0, c_white, image_alpha
	);
	
	draw_text(xPos, yPos + 100, pulseTimer);
}
