// OVERRIDE INHERITED EVENT
if (sprite_index != -1 && !isHit) draw_self();

var trailRGBColor = damageSource.bullet.metadata.trail_rgba_color;
var rgbColor = trailRGBColor.MakeColor();
draw_set_alpha(trailRGBColor.alpha);

draw_line_width_color(
	traceTailPosition.X, traceTailPosition.Y,
	x, y, projectileTrailWidth, rgbColor, rgbColor
);

if (global.DEBUGMODE)
{
	if (!is_undefined(aimAngleLine))
	{
		draw_circle_color(
			aimAngleLine.end_point.X,
			aimAngleLine.end_point.Y,
			3, c_red, c_red, false
		);
	}
}

// RESET DRAW PROPERTIES
ResetDrawProperties();