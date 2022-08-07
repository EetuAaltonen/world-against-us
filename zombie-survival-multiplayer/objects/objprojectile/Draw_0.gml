if (!isBulletHit)
{
	draw_self();
} else {
	draw_circle_color(x, y, (bulletHoleSize * 0.5), c_black, c_black, false);
}