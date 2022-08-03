var viewW = camera_get_view_width(view_camera[0]);
var viewH = camera_get_view_height(view_camera[0]);

var xPos = viewW - 60;
var yPos = viewH - 20;
var vOffset = 20;

draw_set_alpha(0.6);
draw_rectangle_color(
	xPos - 60,
	yPos - 40 - ((vOffset - 1) * magazineSize),
	viewW, viewH,
	c_black, c_black,
	c_black, c_black, false
);

draw_set_alpha(1);
for (var i = 0; i < magazineSize; i++)
{
	if (i < bulletCount)
	{
		draw_sprite_ext(
			spr9mmBullet, 0,
			xPos, yPos - (vOffset * i),
			-0.5, 0.5, 0, c_white, 1
		);
	} else {
		var step = bulletAnimations[i];
		if (step >= 0 && step < 1)
		{
			draw_sprite_ext(
				spr9mmBullet, 0,
				xPos + (100 * step), yPos - (vOffset * i) - (100 * step),
				-0.5, 0.5, -180 * step, c_white, 1
			);
			bulletAnimations[i] += bulletAnimationStep;
		}
	}
}