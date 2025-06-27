// INHERIT THE PARENT EVENT
event_inherited();
if (instanceState != object_index) return;

if (!is_undefined(directionalSpeedVector))
{
	var trailRGBColor = damageSource.bullet.metadata.trail_rgba_color;
	var rgbColor = trailRGBColor.MakeColor();
	draw_set_alpha(trailRGBColor.alpha);
	draw_line_width_color(
		x, y - z,
		x - (bulletTraceVector.X * bulletTraceLengthScale), y - z - (bulletTraceVector.Y * bulletTraceLengthScale),
		bulletTraceWidth, rgbColor, rgbColor
	);
	// RESET DRAW PROPERTIES
	ResetDrawProperties();
}