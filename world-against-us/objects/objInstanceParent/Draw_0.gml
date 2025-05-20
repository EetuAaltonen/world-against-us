if (instanceState != object_index) return;

// DRAW SELF USING Z-AXIS INSTEAD OF X,Y POSITION
//draw_self();

draw_sprite_ext(
	sprite_index, image_index,
	x, y - z, image_xscale, image_yscale,
	image_angle, c_white, image_alpha
);

if (global.DEBUGMODE)
{
	// DRAW WORLD POSITION
	draw_circle_color(x, y, 1, c_lime, c_lime, false);
	
	// DRAW COLLIDER
	if (collider != undefined)
	{
		collider.Draw(self);
	}
}