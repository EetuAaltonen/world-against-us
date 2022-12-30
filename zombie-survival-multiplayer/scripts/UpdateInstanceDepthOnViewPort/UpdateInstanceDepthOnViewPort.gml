function UpdateInstanceDepthOnViewPort()
{
	var offsetY = (sprite_height - sprite_yoffset) * image_yscale;
	depth = clamp(floor(camera_get_view_y(view_camera[0]) - y - offsetY), -camera_get_view_height(view_camera[0]), 0);
}