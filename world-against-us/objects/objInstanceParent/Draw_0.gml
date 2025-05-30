if (instanceState != object_index) return;

if (!is_undefined(skeletalAnimation)) skeletalAnimation.Draw();

// DRAW SELF USING Z-AXIS INSTEAD OF X,Y POSITION
//draw_self();

draw_sprite_ext(
	sprite_index, image_index,
	x, y - z, image_xscale, image_yscale,
	image_angle, image_blend, image_alpha
);

if (global.DEBUGMODE)
{
	// DRAW WORLD POSITION
	draw_circle_color(x, y, 2, c_lime, c_lime, false);
	
	// DRAW COLLIDER
	if (!is_undefined(collider))
	{
		collider.Draw(self);
	}
}