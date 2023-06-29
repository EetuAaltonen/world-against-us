if (sprite_index != -1 && !isHit) draw_self();

var trailRGBColor = damageSource.bullet.metadata.trail_rgba_color;
var rgbColor = trailRGBColor.MakeColor();
draw_set_alpha(trailRGBColor.alpha);

draw_line_width_color(
	traceTailPosition.X, traceTailPosition.Y,
	x, y, projectileTrailWidth, rgbColor, rgbColor
);

// RESET DRAW PROPERTIES
ResetDrawProperties();