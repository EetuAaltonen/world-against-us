function HUDElementIconValuePair(_position, _icon) : HUDElement(_position) constructor
{
	icon = _icon;
	hud_icon_scale = 0.35;
	value_ref = undefined;
	
	static SetValueReference = function(_value_ref)
	{
		value_ref = _value_ref;
	}
	
	static Draw = function()
	{
		draw_sprite_ext(
			icon, 0,
			position.X, position.Y - 15,
			hud_icon_scale, hud_icon_scale,
			0, c_white, 1
		);

		draw_set_font(font_small);
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		
		draw_text(position.X, position.Y + 10, string("{0}%", ceil(value_ref ?? 0)));
				
		// RESET DRAW PROPERTIES
		ResetDrawProperties();
	}
}