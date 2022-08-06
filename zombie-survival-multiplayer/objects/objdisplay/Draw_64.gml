/*if (global.DragItem != noone)
{
	if (global.DragItem.known)
	{
		var mouseX = window_mouse_get_x();
		var mouseY = window_mouse_get_y();
	
		var maxIconSize = 128;
		var iconScale = ScaleSpriteToFitSize(global.DragItem.icon, maxIconSize, maxIconSize);
		var spriteW = sprite_get_width(global.DragItem.icon) * iconScale;
		var spriteH = sprite_get_height(global.DragItem.icon) * iconScale;
		var iconRotation = global.DragItem.rotated ? 90 : 0;
	
		draw_sprite_ext(
			global.DragItem.icon, 0,
			mouseX + (spriteW * 0.5), mouseY + (spriteH * 0.5),
			iconScale, iconScale, iconRotation, c_white, 1
		);
	}
}*/
